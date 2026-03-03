import SwiftUI

protocol ChatListViewProtocol: AnyObject {
    func reload()
}

@MainActor
protocol ChatListPresenterProtocol: ObservableObject {
    var chats: [Chat] { get }
    func viewDidLoad()
    func didTapChat(_ chat: Chat)
}

protocol ChatListInteractorProtocol: Sendable {
    @MainActor
    func fetchChats() async throws -> [Chat]
}

// 👇 Add @MainActor here!
@MainActor
protocol ChatListRouterProtocol: ObservableObject {
    var destination: ChatListRouter.Destination? { get set }
    func openChatDetail(_ chat: Chat)
}
