//
//  AppCoordinatorView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//
import Observation
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    private let logger: Logging

    init(logger: Logging = StudyAppLogger.shared) {
        self.logger = logger
    }

    enum Flow {
        case auth
        case main
    }

    @Published var currentFlow: Flow = .auth

    func switchToMain() {
        logger.notice("Switching app flow to main", category: .navigation, metadata: ["flow": "main"])
        withAnimation {
            currentFlow = .main
        }
    }

    func switchToAuth() {
        logger.notice("Switching app flow to auth", category: .navigation, metadata: ["flow": "auth"])
        withAnimation {
            currentFlow = .auth
        }
    }
}

struct AppCoordinatorView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    var body: some View {
        Group {
            switch coordinator.currentFlow {
            case .auth:
                AuthFlowView()
            case .main:
                MainFlowView()
            }
        }
        .animation(.easeInOut, value: coordinator.currentFlow)
        .ignoresSafeArea()
    }
}

#Preview {
    AppCoordinatorView()
        .environmentObject(AppCoordinator())
        .environmentObject(PopupManager())
}
