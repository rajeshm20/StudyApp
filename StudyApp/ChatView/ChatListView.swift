import SwiftUI

struct ChatListView: View {
    @StateObject var presenter: ChatListPresenter
    // We observe the router directly to trigger navigation updates.
    // We assume the router in the presenter is the concrete ChatListRouter.
    @ObservedObject var router: ChatListRouter

    init(presenter: ChatListPresenter) {
        _presenter = StateObject(wrappedValue: presenter)
        // Force cast is safe here because we know how we assemble it in the Module,
        // but ideally we would use generics or concrete types.
        _router = ObservedObject(wrappedValue: presenter.router as! ChatListRouter)
    }

    var body: some View {
        NavigationStack {
            List(presenter.chats) { chat in
                HStack(spacing: 15) {
                    AsyncImage(url: URL(string: chat.avatarURL ?? "")) { img in
                        img.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(chat.name)
                            .font(.body)
                            .bold()
                        Text(chat.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }

                    Spacer()
                    Text(Self.dateFormatter.string(from: chat.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
                .contentShape(Rectangle()) // Make the whole row tappable
                .onTapGesture {
                    presenter.didTapChat(chat)
                }
            }
            .navigationTitle("Chats")
            .navigationDestination(item: $router.destination) { destination in
                switch destination {
                case let .detail(chat):
                    Text("Chat Detail: \(chat.name)") // Placeholder for Detail View
                }
            }
        }
        .onAppear {
            presenter.viewDidLoad()
        }
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }()
}
