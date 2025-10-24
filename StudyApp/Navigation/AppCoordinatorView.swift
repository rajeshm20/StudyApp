struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.currentFlow {
            case .auth:
                AuthFlowView()
            case .main:
                MainFlowView()
            }
        }
        .environmentObject(coordinator) // 🔥 Inject coordinator into environment
        .animation(.easeInOut, value: coordinator.currentFlow)
    }
}

#Preview {
    AppCoordinatorView()
        .environmentObject(AppCoordinator())
}
