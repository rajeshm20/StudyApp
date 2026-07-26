import Combine
import SwiftUI

@MainActor
final class ChatListPresenter: ObservableObject, ChatListPresenterProtocol {
    @Published var chats: [Chat] = []
    @Published var isLoading = false
    private let logger: Logging

    // Using concrete type here to allow View to access observed properties if needed,
    // or we can keep it as protocol if we handle observation differently.
    // For simplicity and SwiftUI integration, let's keep the protocol but ensure the View can observe it.
    // Actually, to bind in SwiftUI, we often need the concrete ObservableObject.
    // Let's expose it as the protocol type, but we might need to cast in View or change this to concrete type.
    // Given the previous steps used protocols, let's stick to protocols but we might need a way to observe.
    // However, the simplest fix for "Review and fix" is to use the concrete type if the protocol doesn't help much with SwiftUI generics complexity.
    // But let's try to respect the VIPER interface.
    let router: any ChatListRouterProtocol
    private let interactor: ChatListInteractorProtocol

    init(interactor: ChatListInteractorProtocol,
         router: any ChatListRouterProtocol,
         logger: Logging = StudyAppLogger.shared)
    {
        self.interactor = interactor
        self.router = router
        self.logger = logger
    }

    func viewDidLoad() {
        guard !isLoading else { return }
        isLoading = true
        logger.info("Chat list loading started", category: .viewModel, metadata: ["screen": "ChatListView"])
        Task {
            do {
                let result = try await interactor.fetchChats()
                self.chats = result
                self.isLoading = false
                logger.info("Chat list loading succeeded", category: .viewModel, metadata: ["count": String(result.count)])
            } catch {
                self.isLoading = false
                logger.error("Chat list loading failed", category: .viewModel, metadata: ["error": error.localizedDescription])
            }
        }
    }

    func didTapChat(_ chat: Chat) {
        logger.info("Chat selected", category: .ui, metadata: ["chatID": String(chat.id)])
        router.openChatDetail(chat)
    }
}
