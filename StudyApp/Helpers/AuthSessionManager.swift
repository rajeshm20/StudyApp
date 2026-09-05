//
//  AuthSessionManager.swift
//  StudyApp
//
//  Created by Rajesh Mani on 31/08/25.
//

import Foundation
import Security

// MARK: - UserRole
// Mirrors the backend UserRole enum (UserRole.swift).
// The raw string value must exactly match what the server persists in the database.
enum UserRole: String, Codable, CaseIterable {
    case admin      = "admin"
    case principal  = "principal"
    case teacher    = "teacher"
    case student    = "student"

    /// Human-readable display name.
    var displayName: String {
        switch self {
        case .admin:     return "Administrator"
        case .principal: return "Principal"
        case .teacher:   return "Teacher"
        case .student:   return "Student"
        }
    }

    /// Whether this role carries privileged access (not a regular student).
    var isPrivileged: Bool {
        switch self {
        case .admin, .principal, .teacher: return true
        case .student: return false
        }
    }
}

// MARK: - AccountStatus
// Mirrors the backend AccountStatus enum (AccountStatus.swift).
enum AccountStatus: String, Codable {
    /// Account is active — login permitted.
    case active     = "active"
    /// Account exists but has been deactivated.
    case inactive   = "inactive"
    /// Account has been administratively suspended.
    case suspended  = "suspended"
    /// Registration complete but pending admin approval.
    case pending    = "pending"

    var isLoginPermitted: Bool { self == .active }
}

// MARK: - AuthStudent
// Safe public representation of a user account.
// Mirrors Student.Public returned by the backend — never contains passwordHash.
struct AuthStudent: Codable, Equatable {
    let id: UUID?
    // Split name fields (new canonical fields)
    let firstName: String?
    let lastName: String?
    // Legacy combined name — kept for backward compat with existing Keychain sessions
    let name: String
    let email: String
    let role: UserRole
    let status: AccountStatus
    let dob: Date?
    // Legacy combined phone — kept for backward compat
    let phoneNumber: String?
    // New canonical phone fields
    let countryCode: String?
    let contactNumber: String?

    /// Convenience: returns firstName + lastName if available, falls back to `name`.
    var displayName: String {
        let parts = [firstName, lastName].compactMap { $0 }.joined(separator: " ")
        return parts.isEmpty ? name : parts
    }
}

struct LogoutResponse: Decodable, Equatable {
    let message: String
}

// MARK: - Request DTOs (private — not exposed outside this file)

/// New canonical signup request — matches POST /auth/signup/student
private struct StudentSignupRequest: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let confirmPassword: String
    let countryCode: String
    let contactNumber: String
}

private struct LoginRequest: Encodable {
    let email: String
    let password: String
}

private struct ForgotPasswordRequest: Encodable {
    let email: String
}

private struct OTPVerificationRequest: Encodable {
    let email: String
    let code: String
}

private struct ResetPasswordRequest: Encodable {
    let email: String
    let sessionToken: String
    let newPassword: String
    let confirmPassword: String
}

// MARK: - Response DTOs

struct TokenPayload: Decodable {
    let token: String
}

struct LoginResponsePayload: Decodable {
    let user: AuthStudent
    let token: TokenPayload
    let status: Int?
}

private struct AuthErrorPayload: Decodable {
    let message: String?
    let reason: String?
    let error: Bool?
}

struct ForgotPasswordResponse: Decodable {
    let success: Bool
    let message: String
}

struct OTPVerificationResponse: Decodable {
    let success: Bool
    let message: String
    let sessionToken: String?
}

struct ResetPasswordResponse: Decodable {
    let success: Bool
    let message: String
}

// MARK: - HTTP Helpers

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

private enum EndPoint: String {
    /// New canonical student signup endpoint
    case signupStudent  = "/auth/signup/student"
    /// Legacy signup — kept so other callers are not broken
    case signup         = "/auth/signup"
    case login          = "/auth/login"
    case logout         = "/auth/logout"
    case forgotPassword = "/auth/forgot-password"
    case verifyOTP      = "/auth/verify-reset-code"
    case resetPassword  = "/auth/reset-password"

    var path: String { self.rawValue }

    func url(baseURL: String) -> URL {
        URL(string: baseURL + path) ??
        URL(string: "http://localhost:8080/" + path)!
    }
}

// MARK: - AuthSessionManager

@MainActor
final class AuthSessionManager: ObservableObject {
    @Published private(set) var currentUser: AuthStudent?
    @Published private(set) var token: String?
    @Published private(set) var forcedLogoutMessage: String?
    var sessionStore: StoreSessionProtocol
    private let logger: Logging

    init(
        keychainStore: StoreSessionProtocol = KeychainSessionStore(),
        logger: Logging = StudyAppLogger.shared
    ) {
        sessionStore = keychainStore
        self.logger = logger
        restoreSession()
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    // MARK: - Networking Session
    // Configured with TLS 1.2 minimum to mirror backend security enforcement.
    static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.tlsMinimumSupportedProtocolVersion = .TLSv12
        configuration.tlsMaximumSupportedProtocolVersion = .TLSv13
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        #if DEBUG
        return URLSession(configuration: configuration, delegate: LocalhostTrustDelegate(), delegateQueue: nil)
        #else
        return URLSession(configuration: configuration)
        #endif
    }()

    var isAuthenticated: Bool {
        token?.isEmpty == false
    }

    // MARK: - Auth Actions

    /// Signs up a new student via POST /auth/signup/student.
    ///
    /// - Parameters:
    ///   - firstName: Given name (required, max 50 chars).
    ///   - lastName: Family name (required, max 50 chars).
    ///   - email: Valid email address.
    ///   - password: Min 8 chars, must contain at least one letter and one number.
    ///   - confirmPassword: Must exactly match `password`.
    ///   - countryCode: Dialing code starting with '+', e.g. "+91".
    ///   - contactNumber: Subscriber digits only (no country code), 7–15 digits.
    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        confirmPassword: String,
        countryCode: String,
        contactNumber: String
    ) async throws -> AuthStudent {
        let request = StudentSignupRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            countryCode: countryCode,
            contactNumber: contactNumber
        )
        return try await performRequest(
            endpoint: .signupStudent,
            method: .post,
            body: request,
            responseType: AuthStudent.self
        )
    }

    func signIn(email: String, password: String) async throws -> LoginResponsePayload {
        let response = try await performRequest(
            endpoint: .login,
            method: .post,
            body: LoginRequest(email: email, password: password),
            responseType: LoginResponsePayload.self
        )
        sessionStore.saveSession(
            student: response.user,
            token: response.token.token
        )
        currentUser = sessionStore.student
        token = sessionStore.token
        logger.updateUserContext(
            userID: response.user.id?.uuidString,
            sessionID: response.token.token
        )
        logger.notice(
            "Authentication session restored",
            category: .authentication,
            metadata: [
                "userID": response.user.id?.uuidString ?? "unknown",
                "role": response.user.role.rawValue
            ]
        )
        return response
    }

    func ForgotPassword(email: String) async throws -> ForgotPasswordResponse {
        let response = try await performRequest(
            endpoint: .forgotPassword,
            method: .post,
            body: ForgotPasswordRequest(email: email),
            responseType: ForgotPasswordResponse.self
        )

        if response.success {
            let expiresAt = Date().addingTimeInterval(10 * 60) // 10 minutes from now
            sessionStore.saveResetToken(
                "", email: email,
                expiresAt: expiresAt
            )
        }
        return response
    }

    func VerifyOTP(otp: String) async throws -> OTPVerificationResponse {
        guard let email = sessionStore.email else {
            throw AuthServiceError.noEmail
        }
        let response = try await performRequest(
            endpoint: .verifyOTP,
            method: .post,
            body: OTPVerificationRequest(email: email, code: otp),
            responseType: OTPVerificationResponse.self
        )
        if response.success {
            sessionStore.clearResetToken()
            let expiresAt = Date().addingTimeInterval(10 * 60) // 10 minutes from now
            sessionStore.saveResetToken(
                response.sessionToken ?? "", email: email,
                expiresAt: expiresAt
            )
        }
        return response
    }

    func ResetPassword(password: String, confirmPassword: String) async throws -> ResetPasswordResponse {
        let request = ResetPasswordRequest(
            email: sessionStore.email ?? "",
            sessionToken: sessionStore.resetToken ?? "",
            newPassword: password,
            confirmPassword: confirmPassword
        )

        let response = try await performRequest(
            endpoint: .resetPassword,
            method: .post,
            body: request,
            responseType: ResetPasswordResponse.self
        )
        if response.success {
            clearSession()
        }
        return response
    }

    func signOut() async throws -> LogoutResponse {
        guard let token, !token.isEmpty else {
            throw AuthServiceError.requestFailed("You are not logged in.")
        }

        let response = try await performRequest(
            endpoint: .logout,
            method: .post,
            responseType: LogoutResponse.self,
            bearerToken: token
        )

        clearSession()
        logger.notice("User logged out successfully", category: .authentication)
        return response
    }

    func consumeForcedLogoutMessage() -> String? {
        let message = forcedLogoutMessage
        forcedLogoutMessage = nil
        return message
    }

    // MARK: - Session Management

    private func clearSession() {
        currentUser = nil
        token = nil
        sessionStore.clearSession()
        logger.clearUserContext()
    }

    private func restoreSession() {
        currentUser = sessionStore.student
        token = sessionStore.token
        logger.updateUserContext(
            userID: sessionStore.student?.id?.uuidString,
            sessionID: sessionStore.token
        )
    }

    // MARK: - Networking

    private func sanitized(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty else {
            return nil
        }
        return trimmed
    }

    private func performRequest<RequestBody: Encodable, ResponseBody: Decodable>(
        endpoint: EndPoint,
        method: HTTPMethod,
        body: RequestBody,
        responseType: ResponseBody.Type,
        bearerToken: String? = nil
    ) async throws -> ResponseBody {
        let bodyData = try encoder.encode(body)
        return try await performRequest(
            endpoint: endpoint,
            method: method,
            responseType: responseType,
            bearerToken: bearerToken,
            bodyData: bodyData
        )
    }

    private func performRequest<ResponseBody: Decodable>(
        endpoint: EndPoint,
        method: HTTPMethod,
        responseType: ResponseBody.Type,
        bearerToken: String? = nil,
        bodyData: Data? = nil
    ) async throws -> ResponseBody {

        let url = endpoint.url(baseURL: AppConfig.apiBaseURL)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let bearerToken {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = bodyData
        let requestID = UUID().uuidString.prefix(8).description
        let startedAt = ContinuousClock().now

        logger.info(
            "REST request started",
            category: .rest,
            metadata: [
                "requestID": requestID,
                "url": url.absoluteString,
                "method": method.rawValue,
                "headers": prettyHeaders(from: request.allHTTPHeaderFields),
                "requestJSON": RestNetworkLog.requestJSON(from: bodyData),
                "requestSize": String(bodyData?.count ?? 0)
            ]
        )

        let (data, response) = try await Self.urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error(
                "REST request failed with invalid response",
                category: .rest,
                metadata: [
                    "requestID": requestID,
                    "url": url.absoluteString
                ]
            )
            throw AuthServiceError.invalidResponse
        }

        let duration = startedAt.duration(to: ContinuousClock().now)
        let baseResponseMetadata = [
            "requestID": requestID,
            "url": url.absoluteString,
            "method": method.rawValue,
            "statusCode": String(httpResponse.statusCode),
            "latency": "\(duration)",
            "responseSize": String(data.count),
            "responseJSON": RestNetworkLog.responseJSON(from: data)
        ]

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            let error = decodeError(from: data, statusCode: httpResponse.statusCode)
            logger.error(
                "REST request completed with server error",
                category: .rest,
                metadata: baseResponseMetadata.merging([
                    "error": error.localizedDescription
                ]) { _, new in new }
            )
            if shouldForceLogout(statusCode: httpResponse.statusCode, error: error, usedBearerToken: bearerToken != nil) {
                let message = sessionExpiredMessage(from: error)
                clearSession()
                forcedLogoutMessage = message
                logger.warning(
                    "Forced logout triggered due to expired or revoked token",
                    category: .authentication,
                    metadata: [
                        "requestID": requestID,
                        "reason": message
                    ]
                )
            }
            throw error
        }

        do {
            let decoded = try decoder.decode(responseType, from: data)
            logger.info(
                "REST request completed successfully",
                category: .rest,
                metadata: baseResponseMetadata
            )
            return decoded
        } catch {
            logger.error(
                "REST response decoding failed",
                category: .rest,
                metadata: baseResponseMetadata.merging([
                    "error": error.localizedDescription
                ]) { _, new in new }
            )
            throw AuthServiceError.decodingFailed
        }
    }

    private func decodeError(from data: Data, statusCode: Int) -> AuthServiceError {
        if let payload = try? decoder.decode(AuthErrorPayload.self, from: data) {
            let message = payload.message ?? payload.reason
            if let message, !message.isEmpty {
                return .requestFailed(message)
            }
        }

        if statusCode == 401 {
            return .requestFailed("Invalid email or password.")
        }

        return .requestFailed("Request failed with status code \(statusCode).")
    }

    private func shouldForceLogout(statusCode: Int, error: AuthServiceError, usedBearerToken: Bool) -> Bool {
        guard usedBearerToken, statusCode == 401 else { return false }

        switch error {
        case let .requestFailed(message):
            let normalized = message.lowercased()
            return normalized.contains("expired")
                || normalized.contains("revoked")
                || normalized.contains("unauthorized")
                || normalized.contains("invalid authorization")
                || normalized.contains("missing or invalid authorization header")
                || normalized.contains("token already revoked")
        default:
            return true
        }
    }

    private func sessionExpiredMessage(from error: AuthServiceError) -> String {
        switch error {
        case let .requestFailed(message):
            let normalized = message.lowercased()
            if normalized.contains("expired") || normalized.contains("revoked") {
                return "Your session expired. Please sign in again."
            }
            return message
        default:
            return "Your session expired. Please sign in again."
        }
    }

    private func prettyHeaders(from headers: [String: String]?) -> String {
        guard let headers, !headers.isEmpty else { return "<none>" }
        let safeHeaders = headers.mapValues { value in
            value.lowercased().contains("bearer") ? "[REDACTED]" : value
        }
        guard let data = try? JSONSerialization.data(withJSONObject: safeHeaders, options: [.prettyPrinted, .sortedKeys]) else {
            return safeHeaders.description
        }
        return String(decoding: data, as: UTF8.self)
    }
}

// MARK: - AuthServiceError

enum AuthServiceError: LocalizedError {
    case invalidBaseURL
    case invalidResponse
    case decodingFailed
    case requestFailed(String)
    case emailNotFound
    case noEmail
    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return "The backend URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .decodingFailed:
            return "The app could not read the server response."
        case let .requestFailed(message):
            return message
        case .noEmail:
            return "No email id stored!."
        case .emailNotFound:
            return "Email not found!"
        }
    }
}

// MARK: - LocalhostTrustDelegate
// Enables testing HTTPS with self-signed certificates locally in DEBUG builds.
#if DEBUG
final class LocalhostTrustDelegate: NSObject, URLSessionDelegate, Sendable {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        let host = challenge.protectionSpace.host.lowercased()
        if host == "localhost" || host == "127.0.0.1" || host == "openedschool.local" || host.hasSuffix(".charlesproxy.com") {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
#endif

