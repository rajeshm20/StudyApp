    //
    //  KeychainSessionStore.swift
    //  StudyApp
    //
    //  Created by Rajesh Mani on 23/07/26.
    //


import Security
import Foundation

protocol StoreSessionProtocol {
    var student: AuthStudent? { get }
    var token: String? { get }
    var resetToken: String? { get }
    var email: String? { get }
        // Full sign-in session
    func saveSession(student: AuthStudent, token: String)
    func clearSession()

        // Password-reset flow only — separate, short-lived, unrelated to sign-in state
    func saveResetToken(_ token: String, email: String, expiresAt: Date)
    func clearResetToken()
}

final class KeychainSessionStore: StoreSessionProtocol {


    private struct StoredSession: Codable {
        let student: AuthStudent
        let token: String
    }

    private struct StoredResetToken: Codable {
        let email: String
        let token: String
        let expiresAt: Date
    }

    private let sessionKey = "com.openedschool.session"
    private let resetTokenKey = "com.openedschool.resetToken"

        // MARK: - Full session

    var student: AuthStudent? {
        loadSession()?.student
    }
    var email: String? {
        guard let data = loadResetToken() else {
            return nil
        }
        return data.email
    }
    var token: String? {
        loadSession()?.token
    }

    func saveSession(student: AuthStudent, token: String) {
        let session = StoredSession(student: student, token: token)
        guard let data = try? JSONEncoder().encode(session) else { return }
        save(data, forKey: sessionKey)
    }

    func clearSession() {
        delete(forKey: sessionKey)
    }

    private func loadSession() -> StoredSession? {
        guard let data = load(forKey: sessionKey) else { return nil }
        return try? JSONDecoder().decode(StoredSession.self, from: data)
    }

        // MARK: - Reset token (temporary, separate lifecycle)

    var resetToken: String? {
        guard let stored = loadResetToken() else { return nil }
            // Self-expiring: if it's past expiry, treat it as absent and clean up
        guard stored.expiresAt > Date() else {
            clearResetToken()
            return nil
        }
        return stored.token
    }
    private func loadResetToken() -> StoredResetToken? {
        guard let data = load(forKey: resetTokenKey) else { return nil }
        return try? JSONDecoder().decode(StoredResetToken.self, from: data)
    }
    func saveResetToken(_ token: String, email: String, expiresAt: Date) {
        let stored = StoredResetToken(
            email: email,
            token: token,
            expiresAt: expiresAt
        )
        guard let data = try? JSONEncoder().encode(stored) else { return }
        save(data, forKey: resetTokenKey)
    }

    func clearResetToken() {
        delete(forKey: resetTokenKey)
    }

        // MARK: - Keychain primitives

    private func save(_ data: Data, forKey key: String) {
        delete(forKey: key) // remove any existing entry first, avoids duplicate-item errors
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func load(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
