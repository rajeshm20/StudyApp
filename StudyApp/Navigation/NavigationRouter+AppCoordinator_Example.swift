////
////  Router.swift
////  StudyApp
////
////  Created by Rajesh Mani on 21/10/25.
////
///
import SwiftUI
import Observation

// MARK: - Routes
enum AuthRoute_ex: Hashable {
    case signUp
    case signIn
}
enum MainRoute_ex: Hashable {
    case dashboard
    case profile
}


@MainActor
final class AppCoordinator_ex: ObservableObject {
    enum Flow {
        case auth
        case main
    }

    @Published var currentFlow: Flow = .auth

    func switchToMain() {
        withAnimation {
            currentFlow = .main
        }
    }

    func switchToAuth() {
        withAnimation {
            currentFlow = .auth
        }
    }
}

struct AppCoordinatorView_ex: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.currentFlow {
            case .auth:
                AuthFlowView_ex()
            case .main:
                MainFlowView_ex()
            }
        }
        .environmentObject(coordinator) // 🔥 Inject coordinator into environment
        .animation(.easeInOut, value: coordinator.currentFlow)
    }
}

#Preview {
    AppCoordinatorView_ex()
        .environmentObject(AppCoordinator_ex())
}

struct AuthFlowView_ex: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<AuthRoute_ex>()

    var body: some View {
        NavigationStack(path: $router.path) {
            AuthHomeView(router: router)
                .navigationDestination(for: AuthRoute_ex.self) { route in
                    switch route {
                    case .signUp:
                        SetupView(router: router)
                    case .signIn:
                        VerifyView(router: router)
                    }
                }
        }
    }
}

// MARK: - Auth Screens

struct AuthHomeView: View {
    var router: Router<AuthRoute_ex>

    var body: some View {
        VStack(spacing: 20) {
            Text("🔐 Auth Home").font(.largeTitle)
            Button("Go to Setup") { router.push(.signUp) }
        }
        .padding()
    }
}
struct SetupView: View {
    var router: Router<AuthRoute_ex>

    var body: some View {
        VStack(spacing: 20) {
            Text("⚙️ Setup Screen").font(.title)
            Button("Go to Verify") { router.push(.signIn) }
//            Button("Back") { router.pop() }
        }
        .padding()
    }
}

struct VerifyView: View {
    var router: Router<AuthRoute_ex>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("✅ Verify Screen")
                .font(.title)

            Button("Finish Verification → Enter App") {
                coordinator.switchToMain()
            }

            Button("Back") {
                router.pop()
            }
        }
        .padding()
    }
}

struct MainFlowView_ex: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<MainRoute_ex>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MainHomeView(router: router)
                .navigationDestination(for: MainRoute_ex.self) { route in
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

// MARK: - Main Screens

struct MainHomeView: View {
    var router: Router<MainRoute_ex>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            Text("🏠 Main Home")
                .font(.largeTitle)

            Button("Go to Questionnaire") {
                router.push(.dashboard)
            }
            Button("Go to Profile") {
                router.push(.profile)
            }
            Button("Logout → Back to Auth Flow") {
                coordinator.switchToAuth()
            }
        }
        .padding()
    }
}

struct QuestionnaireView: View {
    var router: Router<MainRoute_ex>

    var body: some View {
        VStack(spacing: 20) {
            Text("📝 Questionnaire")
                .font(.title)
            Button("Back") {
                router.pop()
            }
            Button("Go to Profile") {
                router.push(.profile)
            }

        }
        .padding()
    }
}

struct ProfileeView: View {
    var router: Router<MainRoute_ex>

    var body: some View {
        VStack(spacing: 20) {
            Text("👤 Profile Screen").font(.title)
            Button("Back to Root") { router.popToRoot() }
        }
        .padding()
    }
}
