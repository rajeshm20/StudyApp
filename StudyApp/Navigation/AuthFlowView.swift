//
//  AuthFlowView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//


import SwiftUI
import Observation

struct AuthFlowView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<AuthRoute>()

    var body: some View {
        NavigationStack(path: $router.path) {
            LaunchScreenView(router: router)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .onboard:
                        OnboardingView(router: router)
                    case .signUp:
                        SignUpView(router: router)
                    case .otp:
                        OTPVerificationView(router: router)
                    case .userOnboard:
                        OnboardingTabView(router: router)
                    case .signIn:
                        SignInView(router: router)
                    }
                }
        }
    }
}
