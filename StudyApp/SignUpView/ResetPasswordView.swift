//
//  ResetPasswordView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/11/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var password: String = ""
    @State private var passwordError: String? = nil
    @State private var confirmPassword: String = ""
    @State private var confirmPasswordError: String? = nil
    @EnvironmentObject var popupManager: PopupManager

    var router: Router<AuthRoute>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Reset Password")
                .titleStyle()
                .padding([.horizontal], 20)
                .padding(.vertical)
            Text("Enter your password and confirm it.")
                .subtitleStyle()
                .padding([.horizontal], 20)
                .padding(.vertical, 10)
            FormField(title: "New Password", placeholder: "Password", text: $password, isSecure: true, error: $passwordError, completion: {
                validateFields(title: .password)
            })
            .padding(10)
            FormField(title: "Confirm Password", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true, keyboardType: .asciiCapable, error: $confirmPasswordError, completion: {
                validateFields(title: .confirmPassword)
            })
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .padding(.bottom, 15)

            // Sign-In Button (Reusable)
            AppButton(
                title: "Create Password",
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

    // Modify the existing validateFields function
    func validateFields(title: Title) {
        switch title {
        case .password:
            if password.isEmpty {
                passwordError = "Password cannot be empty"
            } else if password.count < 6 {
                passwordError = "Password must be at least 6 characters"
            } else if !ValidationHelper.isValidPassword(password) {
                passwordError = "Password must contain both letters and numbers"
//            } else if password != confirmPassword {
//                passwordError = "Passwords not matching"
            } else {
                passwordError = nil
            }
        case .confirmPassword:
            if confirmPassword.isEmpty {
                confirmPasswordError = "Password cannot be empty"
            } else if password.count < 6 {
                confirmPasswordError = "Password must be at least 6 characters"
            } else if !ValidationHelper.isValidPassword(confirmPassword) {
                confirmPasswordError = "Password must contain both letters and numbers"
            } else if password != confirmPassword {
                confirmPasswordError = "Passwords not matching"
            } else {
                confirmPasswordError = nil
            }
        default:
            break
        }
    }

    // Add this new function
    func validateAllFields() {
        validateFields(title: .password)
        validateFields(title: .confirmPassword)

        // Check if all fields are valid
        let allFieldsValid =
            passwordError == nil && confirmPasswordError == nil

        if allFieldsValid {
            popupManager.show(
                title: "Account information is correct?",
                image: "tick_round",
                message: "Tap accept button to confirm entered details are correct.",
                onClose: {
                    // navigate to signIn
                    router.popToSignIn()
                    popupManager.isVisible = false // Also dismiss the popup
                }
            )
        }
    }
}

#Preview {
    ResetPasswordView(router: Router<AuthRoute>())
}
