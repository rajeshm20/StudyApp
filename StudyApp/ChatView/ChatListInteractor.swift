//
//  ChatListInteractor.swift
//  StudyApp
//
//  Created by Rajesh Mani on 25/11/25.
//

import Foundation

@MainActor
final class ChatListInteractor: ChatListInteractorProtocol, Sendable {
    private let api: ChatAPIServiceProtocol
    private let storage: ChatLocalDataStoreProtocol

    init(api: ChatAPIServiceProtocol, storage: ChatLocalDataStoreProtocol) {
        self.api = api
        self.storage = storage
    }

    func fetchChats() async throws -> [Chat] {
        do {
            let data = try await api.fetchChats()
            storage.saveChats(data)
            return data
        } catch {
            return storage.loadChats() // fallback
        }
    }
}
