//
//  SignInView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/01/25.
//

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
    @EnvironmentObject private var localizationService: LocalizationService

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var router: Router<AuthRoute>
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FormField(title: localizationService.text(.authEmail), placeholder: "study@email.com", text: $email, keyboardType: .emailAddress, error: $emailError, completion: {
                    validateFields(title: .email)
                })
                FormField(title: localizationService.text(.authPassword), placeholder: localizationService.text(.authPasswordPlaceholder), text: $password, isSecure: true, error: $passwordError, completion: {
                    validateFields(title: .password)
                })
                HStack {
                    Spacer()
                    Button(action: {
                        router.push(.forgotPassword)
                    }) {
                        Text(localizationService.text(.authForgotPassword) + "?")
                            .font(horizontalSizeClass == .regular ? .title3 : .footnote)
                            .foregroundColor(Color.cyan)
                    }
                }
                AppButton(
                    title: localizationService.text(.authSignIn),
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

                HStack {
                    Text(localizationService.text(.authDontHaveAccount))
                        .font(horizontalSizeClass == .regular ? .title3 : .footnote)
                        .foregroundColor(.gray)
                    Button(action: {
                        router.push(.signUp)
                    }) {
                        Text(localizationService.text(.authSignUp))
                            .font(horizontalSizeClass == .regular ? .title3 : .footnote)
                            .foregroundColor(Color.cyan)
                    }
                }

                HStack {
                    VStack {
                        Color.gray
                    }
                    .frame(width: 150, height: 0.7)
                    .background(Color.gray.opacity(0.9))
                    Text(localizationService.text(.authOr))
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

                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image("google")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Button(action: {}) {
                        Image("facebook")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }

                    Button(action: {}) {
                        Image("apple")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(horizontalSizeClass == .compact ? 25 : 160)
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle(localizationService.text(.authSignIn))
        .navigationBarTitleDisplayMode(.large)
        .studyAppLoadingOverlay(
            isPresented: isSubmitting,
            symbol: "person.crop.circle.badge.checkmark",
            tint: .cyan,
            title: localizationService.text(.authSigningInTitle),
            message: localizationService.text(.authSigningInMessage)
        )
        .alert(localizationService.text(.authSignInFailed), isPresented: $showAuthAlert) {
            Button(localizationService.text(.commonOk), role: .cancel) {}
        } message: {
            Text(authAlertMessage)
        }
    }

    func validateFields(title: Title) {
        switch title {
        case .email:
            emailError = ValidationHelper.isValidEmail(email) ? nil : localizationService.text(.authInvalidEmail)
        case .password:
            if password.isEmpty {
                passwordError = localizationService.text(.authEmptyPassword)
            } else if password.count < 6 {
                passwordError = localizationService.text(.authPasswordShort)
            } else if !ValidationHelper.isValidPassword(password) {
                passwordError = localizationService.text(.authPasswordWeak)
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
                        title: localizationService.text(.authSignedInTitle),
                        image: "tick_round",
                        message: localizationService.text(.authSignedInMessage),
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
                    popupManager.show(
                        title: localizationService.text(.authSignInFailed),
                        image: "invalid",
                        message: authAlertMessage,
                        onPrimary: {
                            popupManager.dismiss()
                        }
                    )
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
