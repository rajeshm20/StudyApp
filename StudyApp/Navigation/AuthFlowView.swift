//
//  AuthFlowView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//

import Observation
import SwiftUI

struct AuthFlowView: View {
    //    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<AuthRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            LaunchScreenView(router: router)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .onboard:
                        OnboardingView(router: router)
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .navigationBar)
                            .toolbarBackground(.hidden, for: .navigationBar)
                    case .signUp:
                        SignUpView(router: router)
                    case .otp:
                        OTPVerificationView(router: router)
                    case .userOnboard:
                        OnboardingTabView(router: router)
                    case .signIn:
                        SignInView(router: router)
                    case .forgotPassword:
                        ForgotPasswordView(router: router)
                    case .resetPassword:
                        ResetPasswordView(router: router)
                    }
                }
            }
    }
}

#Preview {
    AuthFlowView()
        .environmentObject(AppCoordinator())
}
