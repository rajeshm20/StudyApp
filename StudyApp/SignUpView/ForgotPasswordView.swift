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
                title: "Reset Password",
                style: .filled,
                foregroundColor: .white,
                backgroundColor: .cyan,
                cornerRadius: 8,
                font: .system(size: 18, weight: .bold),
                fullWidth: true,
                isLoading: false,
                isDisabled: false
            ) {
                validateAllFields()
            }
            .padding(.horizontal)
        }
        .padding()
        Spacer()
    }

    // Add this new function
    func validateAllFields() {
        validateFields(title: .email)

        // Check if all fields are valid
        let allFieldsValid =
            emailError == nil

        if allFieldsValid {
            popupManager.show(
                title: "Account information is correct?",
                image: "tick_round",
                message: "Tap accept button to confirm entered details are correct.",
                onClose: {
                    // Dynamic navigation or any logic goes here:
                    router.push(.resetPassword)
                    popupManager.isVisible = false // Also dismiss the popup
                }
            )
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
