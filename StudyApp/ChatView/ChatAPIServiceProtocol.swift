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
    func fetchChats() async throws -> [Chat] {
        let url = URL(string: "https://example.com/api/chats")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Chat].self, from: data)
    }
}
