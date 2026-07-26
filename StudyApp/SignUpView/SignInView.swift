//
//  SignInView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/01/25.
//

import Observation
import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var authAlertMessage = ""
    @State private var showAuthAlert = false
    @State private var isSubmitting = false
    @EnvironmentObject var popupManager: PopupManager
    @EnvironmentObject var authSession: AuthSessionManager

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var navigationManager = NavigationManager()
    var router: Router<AuthRoute>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Email Field
                FormField(title: "Email", placeholder: "study@email.com", text: $email, keyboardType: .emailAddress, error: $emailError, completion: {
                    validateFields(title: .email)
                })
                FormField(title: "Password", placeholder: "Your password", text: $password, isSecure: true, error: $passwordError, completion: { validateFields(title: .password) })
                // Forgot Password
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle forgot password
                        router.push(.forgotPassword)
                    }) {
                        Text("Forgot Password?")
                            .font(horizontalSizeClass == .regular ? .title3 : .footnote)
                            .foregroundColor(Color.cyan)
                    }
                }
                // Sign-In Button (Reusable)
                AppButton(
                    title: "Sign In",
                    style: .filled,
                    foregroundColor: .white,
                    backgroundColor: .cyan,
                    cornerRadius: 8,
                    font: .system(size: 18, weight: .bold),
                    fullWidth: true,
                    isLoading: isSubmitting,
                    isDisabled: isSubmitting
                ) {
                    submitSignIn()
                }
                .padding()

                // Sign Up Option
                HStack {
                    Text("Don’t have an account?")
                        .font(horizontalSizeClass == .regular ? .title3 : .footnote)
                        .foregroundColor(.gray)
                    Button(action: {
                        // Handle sign-up action
                        router.push(.signUp)
                    }) {
                        Text("Sign Up")
                            .font(horizontalSizeClass == .regular ? .title3 : .footnote)
                            .foregroundColor(Color.cyan)
                    }
                }

                // OR Divider
                HStack {
                    VStack {
                        Color.gray
                    }
                    .frame(width: 150, height: 0.7)
                    .background(Color.gray.opacity(0.9))
                    Text("OR")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .dynamicTypeSize(.small)
                        .padding(.horizontal, 2)
                    VStack {
                        Color.gray
                    }
                    .frame(width: 150, height: 0.8)
                    .background(Color.gray.opacity(0.7))
                }
                .padding(.vertical)

                // Social Login Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Handle Google login
                    }) {
                        Image("google") // Replace with your Google icon
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Button(action: {
                        // Handle Facebook login
                    }) {
                        Image("facebook") // Replace with your Facebook icon
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Button(action: {
                        // Handle Apple login
                    }) {
                        Image("apple") // Replace with your Apple icon
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(horizontalSizeClass == .compact ? 25 : 160)
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.large)
        .studyAppLoadingOverlay(
            isPresented: isSubmitting,
            symbol: "person.crop.circle.badge.checkmark",
            tint: .cyan,
            title: "Signing In",
            message: "Verifying your credentials and preparing your account."
        )
        .alert("Sign In Failed", isPresented: $showAuthAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authAlertMessage)
        }
    }

    // Modify the existing validateFields function
    func validateFields(title: Title) {
        switch title {
        case .email:
            emailError = ValidationHelper.isValidEmail(email) ? nil : "Please enter a valid email"
        case .password:
            if password.isEmpty {
                passwordError = "Password cannot be empty"
            } else if password.count < 6 {
                passwordError = "Password must be at least 6 characters"
            } else if !ValidationHelper.isValidPassword(password) {
                passwordError = "Password must contain both letters and numbers"
            } else {
                passwordError = nil
            }
        default:
            break
        }
    }

    // Add this new function
    func validateAllFields() {
        validateFields(title: .email)
        validateFields(title: .password)

        // Check if all fields are valid
        let allFieldsValid =
            emailError == nil && passwordError == nil

        guard allFieldsValid else { return }
    }

    private func submitSignIn() {
        validateAllFields()
        guard emailError == nil, passwordError == nil else { return }
        guard !isSubmitting else { return }

        isSubmitting = true
        Task {
            do {
                let response = try await authSession.signIn(
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password
                )
                await MainActor.run {
                    isSubmitting = false
                    popupManager.show(
                        title: "Signed in",
                        image: "tick_round",
                        message: "Your account has been connected successfully.",
                        onPrimary: {
                            popupManager.dismiss()
                            coordinator.switchToMain()
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
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(router: Router<AuthRoute>())
    }
}
