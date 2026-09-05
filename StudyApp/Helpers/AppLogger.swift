//
//  AppLogger.swift
//  StudyApp
//

import Foundation
import OSLog
import SwiftUI
import UIKit

enum LogLevel: Int, Comparable, CaseIterable, Sendable {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
    case critical
    case fault

    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var emoji: String {
        switch self {
        case .trace: "🔍"
        case .debug: "🧭"
        case .info: "🟢"
        case .notice: "🔵"
        case .warning: "🟡"
        case .error: "🔴"
        case .critical: "🔥"
        case .fault: "💥"
        }
    }

    var title: String {
        switch self {
        case .trace: "TRACE"
        case .debug: "DEBUG"
        case .info: "INFO"
        case .notice: "NOTICE"
        case .warning: "WARNING"
        case .error: "ERROR"
        case .critical: "CRITICAL"
        case .fault: "FAULT"
        }
    }

    var colorCode: String {
        switch self {
        case .trace: "\u{001B}[0;37m"
        case .debug: "\u{001B}[0;36m"
        case .info: "\u{001B}[0;32m"
        case .notice: "\u{001B}[0;34m"
        case .warning: "\u{001B}[0;33m"
        case .error: "\u{001B}[0;31m"
        case .critical: "\u{001B}[0;35m"
        case .fault: "\u{001B}[1;31m"
        }
    }

    var osLogType: OSLogType {
        switch self {
        case .trace, .debug:
            .debug
        case .info:
            .info
        case .notice:
            .default
        case .warning:
            .error
        case .error:
            .error
        case .critical, .fault:
            .fault
        }
    }
}

enum LogCategory: String, CaseIterable, Sendable {
    case app = "App"
    case authentication = "Authentication"
    case navigation = "Navigation"
    case viewModel = "ViewModel"
    case repository = "Repository"
    case networking = "Networking"
    case api = "API"
    case database = "Database"
    case storage = "Storage"
    case security = "Security"
    case performance = "Performance"
    case ui = "UI"
    case graphQL = "GraphQL"
    case rest = "REST"
    case cache = "Cache"
    case notification = "Notification"
    case lifecycle = "Lifecycle"
    case analytics = "Analytics"
    case backgroundTask = "BackgroundTask"
    case media = "Media"
    case audio = "Audio"
    case video = "Video"
    case download = "Download"
    case upload = "Upload"
    case deepLink = "DeepLink"
    case location = "Location"
    case bluetooth = "Bluetooth"
    case purchase = "Purchase"
    case subscription = "Subscription"
}

struct LogConfiguration: Sendable {
    let subsystem: String
    let minimumLevel: LogLevel
    let enableConsoleColors: Bool
    let includeFileLogging: Bool
    let includeConsoleLogging: Bool
    let includeOSLogging: Bool
    let maxFileSizeBytes: Int
    let retentionDays: Int

    static let `default` = LogConfiguration(
        subsystem: Bundle.main.bundleIdentifier ?? "StudyApp",
        minimumLevel: .trace,
        enableConsoleColors: true,
        includeFileLogging: true,
        includeConsoleLogging: true,
        includeOSLogging: true,
        maxFileSizeBytes: 1_000_000,
        retentionDays: 7
    )
}

struct LogEvent: Sendable {
    let level: LogLevel
    let category: LogCategory
    let message: String
    let metadata: [String: String]
    let file: String
    let function: String
    let line: Int
    let timestamp: Date
}

protocol Logging: Sendable {
    func log(_ level: LogLevel, _ message: String, category: LogCategory, metadata: [String: String], file: String, function: String, line: Int)
    func measure<T>(_ name: String, category: LogCategory, operation: @escaping () async throws -> T) async rethrows -> T
    func updateUserContext(userID: String?, sessionID: String?)
    func clearUserContext()
}

protocol LogDestination: Sendable {
    func write(formatted: String, event: LogEvent) async
}

private actor LoggerContextStore {
    var userID: String?
    var sessionID: String?

    func update(userID: String?, sessionID: String?) {
        self.userID = userID
        self.sessionID = sessionID
    }

    func snapshot() -> (userID: String?, sessionID: String?) {
        (userID, sessionID)
    }
}

private struct LoggerMetadataFactory {
    @MainActor static func build(
        category: LogCategory,
        extra: [String: String],
        file: String,
        function: String,
        line: Int,
        userID: String?,
        sessionID: String?
    ) -> [String: String] {
        var metadata = extra
        metadata["timestamp"] = ISO8601DateFormatter().string(from: Date())
        metadata["thread"] = Thread.isMainThread ? "Main" : "Background"
        metadata["queue"] = String(cString: __dispatch_queue_get_label(nil), encoding: .utf8) ?? "unknown"
        metadata["file"] = URL(fileURLWithPath: file).lastPathComponent
        metadata["function"] = function
        metadata["line"] = String(line)
        metadata["module"] = Bundle.main.bundleIdentifier ?? "StudyApp"
        metadata["appVersion"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        metadata["buildNumber"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        metadata["device"] = UIDevice.current.model
        metadata["osVersion"] = UIDevice.current.systemVersion
        metadata["memoryMB"] = String(format: "%.2f", ProcessInfo.processInfo.physicalMemory > 0 ? Double(memoryFootprint()) / 1_048_576 : 0)
        metadata["cpuUsage"] = "n/a"
        metadata["networkStatus"] = "unknown"
        metadata["requestID"] = metadata["requestID"] ?? UUID().uuidString.prefix(8).description
        metadata["correlationID"] = metadata["correlationID"] ?? UUID().uuidString
        metadata["category"] = category.rawValue
        if let userID {
            metadata["userID"] = userID
        }
        if let sessionID {
            metadata["sessionID"] = sessionID
        }
        return PrivacyRedactor.redact(metadata)
    }

    private static func memoryFootprint() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        return result == KERN_SUCCESS ? info.resident_size : 0
    }
}

private enum PrivacyRedactor {
    private static let patterns: [String] = [
        "(?i)bearer\\s+[A-Za-z0-9\\-\\._~\\+\\/]+=*",
        "(?i)\"?(password|accessToken|refreshToken|token|otp|phoneNumber|email|address)\"?\\s*[:=]\\s*\"[^\"]*\"",
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
        "\\b\\d{10,16}\\b",
        "\\b\\d{3,6}\\b"
    ]

    static func redact(_ string: String) -> String {
        patterns.reduce(string) { partial, pattern in
            partial.replacingOccurrences(of: pattern, with: "[REDACTED]", options: .regularExpression)
        }
    }

    static func redact(_ metadata: [String: String]) -> [String: String] {
        metadata.mapValues(redact)
    }
}

private struct ConsoleLogFormatter {
    let configuration: LogConfiguration

    func format(_ event: LogEvent) -> String {
        let reset = configuration.enableConsoleColors ? "\u{001B}[0m" : ""
        let prefix = configuration.enableConsoleColors ? event.level.colorCode : ""
        let metadataString = event.metadata
            .sorted { $0.key < $1.key }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: "\n")
        return """
        \(prefix)────────────────────────────────────────────
        \(event.level.emoji) \(event.level.title)
        Time: \(ISO8601DateFormatter().string(from: event.timestamp))
        Category: \(event.category.rawValue)
        Function: \(event.function)
        File: \(URL(fileURLWithPath: event.file).lastPathComponent)
        Line: \(event.line)
        Message: \(PrivacyRedactor.redact(event.message))
        Metadata:
        \(metadataString)
        ────────────────────────────────────────────\(reset)
        """
    }
}

private struct ConsoleDestination: LogDestination {
    func write(formatted: String, event: LogEvent) async {
        Swift.print(formatted)
    }
}

private struct OSLogDestination: LogDestination {
    let subsystem: String

    func write(formatted: String, event: LogEvent) async {
        let logger = Logger(subsystem: subsystem, category: event.category.rawValue)
        logger.log(level: event.level.osLogType, "\(PrivacyRedactor.redact(event.message), privacy: .private(mask: .hash))")
    }
}

private actor FileLogDestination: LogDestination {
    private let configuration: LogConfiguration
    private let fileManager = FileManager.default

    init(configuration: LogConfiguration) {
        self.configuration = configuration
    }

    func write(formatted: String, event: LogEvent) async {
        do {
            let url = try logFileURL(for: event.timestamp)
            try rotateIfNeeded(at: url)
            let data = (formatted + "\n").data(using: .utf8) ?? Data()
            if !fileManager.fileExists(atPath: url.path) {
                fileManager.createFile(atPath: url.path, contents: data)
            } else {
                let handle = try FileHandle(forWritingTo: url)
                defer { try? handle.close() }
                try handle.seekToEnd()
                try handle.write(contentsOf: data)
            }
            try cleanupExpiredFiles(in: url.deletingLastPathComponent())
        } catch {
            let logger = Logger(subsystem: configuration.subsystem, category: "FileLogging")
            logger.error("File logging failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func logFileURL(for date: Date) throws -> URL {
        let directory = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Logs", isDirectory: true)
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return directory.appendingPathComponent("studyapp-\(formatter.string(from: date)).log")
    }

    private func rotateIfNeeded(at url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        let size = (try fileManager.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.intValue ?? 0
        guard size >= configuration.maxFileSizeBytes else { return }
        let formatter = ISO8601DateFormatter()
        let rotatedURL = url.deletingPathExtension().appendingPathExtension("\(formatter.string(from: Date())).log")
        try fileManager.moveItem(at: url, to: rotatedURL)
    }

    private func cleanupExpiredFiles(in directory: URL) throws {
        let urls = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)
        let cutoff = Calendar.current.date(byAdding: .day, value: -configuration.retentionDays, to: Date()) ?? .distantPast
        for url in urls {
            let values = try url.resourceValues(forKeys: [.contentModificationDateKey])
            if let modified = values.contentModificationDate, modified < cutoff {
                try? fileManager.removeItem(at: url)
            }
        }
    }
}

private actor LogPipeline {
    private let configuration: LogConfiguration
    private let formatter: ConsoleLogFormatter
    private let contextStore = LoggerContextStore()
    private let destinations: [LogDestination]

    init(configuration: LogConfiguration) {
        self.configuration = configuration
        formatter = ConsoleLogFormatter(configuration: configuration)
        var builtDestinations: [LogDestination] = []
        if configuration.includeConsoleLogging {
            builtDestinations.append(ConsoleDestination())
        }
        if configuration.includeOSLogging {
            builtDestinations.append(OSLogDestination(subsystem: configuration.subsystem))
        }
        if configuration.includeFileLogging {
            builtDestinations.append(FileLogDestination(configuration: configuration))
        }
        destinations = builtDestinations
    }

    func updateContext(userID: String?, sessionID: String?) async {
        await contextStore.update(userID: userID, sessionID: sessionID)
    }

    func process(level: LogLevel, category: LogCategory, message: String, metadata: [String: String], file: String, function: String, line: Int) async {
        guard level >= configuration.minimumLevel else { return }
        let context = await contextStore.snapshot()
        let event = await LogEvent(
            level: level,
            category: category,
            message: PrivacyRedactor.redact(message),
            metadata: LoggerMetadataFactory.build(
                category: category,
                extra: metadata,
                file: file,
                function: function,
                line: line,
                userID: context.userID,
                sessionID: context.sessionID
            ),
            file: file,
            function: function,
            line: line,
            timestamp: Date()
        )
        let formatted = formatter.format(event)
        for destination in destinations {
            await destination.write(formatted: formatted, event: event)
        }
    }
}

final class StudyAppLogger: Logging, @unchecked Sendable {
    static let shared = StudyAppLogger()

    private let pipeline: LogPipeline

    init(configuration: LogConfiguration = .default) {
        pipeline = LogPipeline(configuration: configuration)
    }

    func updateUserContext(userID: String?, sessionID: String?) {
        Task { await pipeline.updateContext(userID: userID, sessionID: sessionID) }
    }

    func clearUserContext() {
        updateUserContext(userID: nil, sessionID: nil)
    }

    func measure<T>(_ name: String, category: LogCategory = .performance, operation: @escaping () async throws -> T) async rethrows -> T {
        let clock = ContinuousClock()
        let start = clock.now
        let result = try await operation()
        let duration = start.duration(to: clock.now)
        info("Performance measurement completed", category: category, metadata: [
            "name": name,
            "duration": "\(duration)"
        ])
        return result
    }

    func log(_ level: LogLevel, _ message: String, category: LogCategory, metadata: [String: String], file: String, function: String, line: Int) {
        Task {
            await pipeline.process(
                level: level,
                category: category,
                message: message,
                metadata: metadata,
                file: file,
                function: function,
                line: line
            )
        }
    }
}

extension Logging {
    func trace(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.trace, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func debug(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.debug, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func info(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.info, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func notice(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.notice, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func warning(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.warning, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func error(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.error, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func critical(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.critical, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
    func fault(_ message: @autoclosure () -> String, category: LogCategory, metadata: [String: String] = [:], file: String = #fileID, function: String = #function, line: Int = #line) {
        log(.fault, message(), category: category, metadata: metadata, file: file, function: function, line: line)
    }
}

struct RestNetworkLog {
    static func requestJSON(from bodyData: Data?) -> String {
        prettyPrintedJSON(from: bodyData) ?? "<empty>"
    }

    static func responseJSON(from data: Data) -> String {
        prettyPrintedJSON(from: data) ?? String(decoding: data, as: UTF8.self)
    }

    private static func prettyPrintedJSON(from data: Data?) -> String? {
        guard let data, !data.isEmpty else { return nil }
        guard let object = try? JSONSerialization.jsonObject(with: data) else { return nil }
        guard let formatted = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]) else { return nil }
        return String(decoding: formatted, as: UTF8.self)
    }
}

private struct LoggerEnvironmentKey: EnvironmentKey {
    static let defaultValue: Logging = StudyAppLogger.shared
}

extension EnvironmentValues {
    var logger: Logging {
        get { self[LoggerEnvironmentKey.self] }
        set { self[LoggerEnvironmentKey.self] = newValue }
    }
}

private struct ScreenLoggingModifier: ViewModifier {
    @Environment(\.logger) private var logger
    let screenName: String

    func body(content: Content) -> some View {
        content
            .onAppear {
                logger.info("Screen appeared", category: .ui, metadata: ["screen": screenName])
            }
            .onDisappear {
                logger.info("Screen disappeared", category: .ui, metadata: ["screen": screenName])
            }
    }
}

extension View {
    func screenLog(_ screenName: String) -> some View {
        modifier(ScreenLoggingModifier(screenName: screenName))
    }
}
