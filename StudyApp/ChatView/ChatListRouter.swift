import SwiftUI

@MainActor
final class ChatListRouter: ChatListRouterProtocol {
    enum Destination: Identifiable, Hashable {
        case detail(Chat)

        var id: String {
            switch self {
            case let .detail(chat): chat.id
            }
        }
    }

    @Published var destination: Destination?

    func openChatDetail(_ chat: Chat) {
        destination = .detail(chat)
    }
}
