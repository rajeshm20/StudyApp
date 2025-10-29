//
//  AppCoordinatorView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//
import SwiftUI
import Observation

@MainActor
final class AppCoordinator: ObservableObject {
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
    }
}

#Preview {
    AppCoordinatorView()
        .environmentObject(AppCoordinator())
}
