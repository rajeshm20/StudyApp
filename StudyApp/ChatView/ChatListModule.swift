import SwiftUI

enum ChatListModule {
    @MainActor
    static func build() -> some View {
        let api = ChatAPIService()
        let storage = ChatLocalDataStore()

        let interactor = ChatListInteractor(api: api, storage: storage)
        let router = ChatListRouter()

        let presenter = ChatListPresenter(
            interactor: interactor,
            router: router
        )

        return ChatListView(presenter: presenter)
    }
}
