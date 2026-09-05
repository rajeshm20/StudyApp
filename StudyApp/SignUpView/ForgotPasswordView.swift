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
    @EnvironmentObject private var localizationService: LocalizationService
    var router: Router<AuthRoute>
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(localizationService.text(.authForgotPassword))
                .titleStyle()
                .padding([.horizontal], 20)
                .padding(.vertical)
            Text(localizationService.text(.authForgotPasswordDescription))
                .subtitleStyle()
                .padding([.horizontal], 20)
            FormField(title: localizationService.text(.authEmail), placeholder: "study@email.com", text: $email, keyboardType: .emailAddress, error: $emailError, completion: {
                validateFields(title: .email)
            })
            .padding(10)
            
            AppButton(
                title: localizationService.text(.authVerifyEmail),
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
            title: localizationService.text(.authVerifyEmail),
            message: localizationService.text(.authForgotPasswordDescription)
        )
        .alert(localizationService.text(.authVerifyEmail), isPresented: $showAuthAlert) {
            Button(localizationService.text(.commonOk), role: .cancel) {}
        } message: {
            Text(authAlertMessage)
        }
        
        Spacer()
    }
    
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
                        title: response.success == true ? localizationService.text(.authEmailVerifiedTitle) : response.message,
                        image: response.success == true ? "tick_round" : "notfound",
                        message: localizationService.text(.authCheckYourEmail),
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
    
    func validateFields(title: Title) {
        switch title {
        case .email:
            emailError = ValidationHelper.isValidEmail(email) ? nil : localizationService.text(.authInvalidEmail)
        default:
            break
        }
    }
}

#Preview {
    ForgotPasswordView(router: Router<AuthRoute>())
}
