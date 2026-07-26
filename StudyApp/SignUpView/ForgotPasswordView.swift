    //
    //  ForgotPasswordView.swift
    //  StudyApp
    //
    //  Created by Rajesh Mani on 11/11/25.
    //

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var emailError: String? = nil
    @EnvironmentObject var popupManager: PopupManager
    @State private var authAlertMessage = ""
    @State private var showAuthAlert = false
    @State private var isSubmitting = false
    @EnvironmentObject var authSession: AuthSessionManager
    @Environment(\.dismiss) private var dismiss
    var router: Router<AuthRoute>
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Forgot Password")
                .titleStyle()
                .padding([.horizontal], 20)
                .padding(.vertical)
            Text("Enter your registered email id to reset your password.")
                .subtitleStyle()
                .padding([.horizontal], 20)
            FormField(title: "Email", placeholder: "study@email.com", text: $email, keyboardType: .emailAddress, error: $emailError, completion: {
                validateFields(title: .email)
            })
            .padding(10)
            
                // Sign-In Button (Reusable)
            AppButton(
                title: "Verify Email",
                style: .filled,
                foregroundColor: .white,
                backgroundColor: .cyan,
                cornerRadius: 8,
                font: .system(size: 18, weight: .bold),
                fullWidth: true,
                isLoading: isSubmitting,
                isDisabled: isSubmitting
            ) {
                verifyEMail()
            }
            .padding(.horizontal)
        }
        .padding()
        .studyAppLoadingOverlay(
            isPresented: isSubmitting,
            symbol: "envelope.badge",
            tint: .cyan,
            title: "Verifying Email",
            message: "Checking your account and sending the reset instructions."
        )
        .alert("Email verification Failed", isPresented: $showAuthAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authAlertMessage)
        }
        
        Spacer()
    }
    
        // Add this new function
    func verifyEMail() {
        validateFields(title: .email)
        
        // Check if email field valid
        guard emailError == nil else { return }
        guard !isSubmitting else { return }
        isSubmitting = true

        Task {
            do {
                let response = try await authSession.ForgotPassword(
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines)
                )
                await MainActor.run {
                    isSubmitting = false
                    popupManager.show(
                        title: response.success == true ? "Email Successfully Verified" : response.message,
                        image: response.success == true ? "tick_round" : "notfound",
                        message: "Check your email",
                        onPrimary: {
                            response.success ? router.push(.verifyOTP) : dismiss()
                            popupManager.dismiss()
                        }
                    )
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    authAlertMessage = error.localizedDescription
                    showAuthAlert = true
                }
            }
        }
    }
    
        // Modify the existing validateFields function
    func validateFields(title: Title) {
        switch title {
            case .email:
                emailError = ValidationHelper.isValidEmail(email) ? nil : "Invalid email address"
            default:
                break
        }
    }
}

#Preview {
    ForgotPasswordView(router: Router<AuthRoute>())
}
