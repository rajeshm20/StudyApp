import Foundation

protocol ChatLocalDataStoreProtocol: Sendable {
    func saveChats(_ chats: [Chat])
    func loadChats() -> [Chat]
}

final class ChatLocalDataStore: ChatLocalDataStoreProtocol, Sendable {
    private let key = "local_chat_cache"

    func saveChats(_ chats: [Chat]) {
        guard let data = try? JSONEncoder().encode(chats) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func loadChats() -> [Chat] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let cached = try? JSONDecoder().decode([Chat].self, from: data)
        else {
            return []
        }
        return cached
    }
}
