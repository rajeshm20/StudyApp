//
//  ChatAPIServiceProtocol.swift
//  StudyApp
//
//  Created by Rajesh Mani on 25/11/25.
//

import Foundation

protocol ChatAPIServiceProtocol: Sendable {
    func fetchChats() async throws -> [Chat]
}

@MainActor
final class ChatAPIService: ChatAPIServiceProtocol, Sendable {
    private let logger: Logging

    init(logger: Logging = StudyAppLogger.shared) {
        self.logger = logger
    }

    func fetchChats() async throws -> [Chat] {
        let url = URL(string: "https://example.com/api/chats")!
        let requestID = UUID().uuidString.prefix(8).description
        let startedAt = ContinuousClock().now
        logger.info(
            "REST request started",
            category: .rest,
            metadata: [
                "requestID": requestID,
                "url": url.absoluteString,
                "method": "GET",
                "requestJSON": "<empty>"
            ]
        )
        let (data, response) = try await URLSession.shared.data(from: url)
        let duration = startedAt.duration(to: ContinuousClock().now)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        logger.info(
            "REST request completed",
            category: .rest,
            metadata: [
                "requestID": requestID,
                "url": url.absoluteString,
                "method": "GET",
                "statusCode": String(statusCode),
                "latency": "\(duration)",
                "responseSize": String(data.count),
                "responseJSON": RestNetworkLog.responseJSON(from: data)
            ]
        )
        return try JSONDecoder().decode([Chat].self, from: data)
    }
}
