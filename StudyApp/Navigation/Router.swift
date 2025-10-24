@MainActor
final class Router<Route: Hashable>: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

// MARK: - Routes
enum AuthRoute: Hashable {
    case onboard
    case signUp
    case otp
    case signIn
}
enum MainRoute: Hashable {
    case dashboard
    case profile
}
