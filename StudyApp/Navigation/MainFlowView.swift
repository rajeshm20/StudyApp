struct MainFlowView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<MainRoute_ex>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MainHomeView(router: router)
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .dashboard:
                        QuestionnaireView(router: router)
                    case .profile:
                        ProfileeView(router: router)
                    }
                }
           }
    }
}
