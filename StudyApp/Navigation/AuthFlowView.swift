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
                .screenLog("LaunchScreenView")
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .onboard:
                        OnboardingView(router: router)
                            .screenLog("OnboardingView")
                            .navigationBarBackButtonHidden(true)
                            .toolbar(.hidden, for: .navigationBar)
                            .toolbarBackground(.hidden, for: .navigationBar)
                    case .signUp:
                        SignUpView(router: router)
                            .screenLog("SignUpView")
                    case .otp:
                        OTPVerificationView(router: router)
                            .screenLog("OTPVerificationView")
                    case .userOnboard:
                        OnboardingTabView(router: router)
                            .screenLog("OnboardingTabView")
                    case .signIn:
                        SignInView(router: router)
                            .screenLog("SignInView")
                    case .forgotPassword:
                        ForgotPasswordView(router: router)
                            .screenLog("ForgotPasswordView")
                    case .resetPassword:
                        ResetPasswordView(router: router)
                            .screenLog("ResetPasswordView")
                    case .verifyOTP:
                        ResetPasswordOTPView(router: router)
                            .screenLog("ResetPasswordOTPView")
                    }
                }
            }
        }
}

#Preview {
    AuthFlowView()
        .environmentObject(AppCoordinator())
}
