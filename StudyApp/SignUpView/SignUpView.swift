//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//  Updated to use POST /auth/signup/student (canonical new endpoint).

import SwiftUI

enum Title: String {
    case name = "Name"
    case firstName = "First Name"
    case lastName = "Last Name"
    case email = "Email"
    case password = "Password"
    case confirmPassword = "Confirm Password"
    case otp = "OTP"
    case countryCode = "Country Code"
    case contactNumber = "Contact Number"
    case phoneNumber = "Phone number"
    case terms = "Terms"
}

struct SignUpView: View {
    // MARK: - Form state (new canonical fields)
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var countryCode: String = "+91"
    @State private var contactNumber: String = ""
    @State private var agreeToTerms: Bool = false

    // MARK: - Per-field error states
    @State private var firstNameError: String? = nil
    @State private var lastNameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var countryCodeError: String? = nil
    @State private var contactNumberError: String? = nil
    @State private var termsError: String? = nil

    @State private var authAlertMessage = ""
    @State private var showAuthAlert = false
    @State private var isSubmitting = false

    @EnvironmentObject var popupManager: PopupManager
    @EnvironmentObject var authSession: AuthSessionManager
    @EnvironmentObject private var localizationService: LocalizationService
    var router: Router<AuthRoute>

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // First Name
                    FormField(
                        title: localizationService.text(.authFirstName),
                        placeholder: localizationService.text(.authFirstNamePlaceholder),
                        text: $firstName,
                        error: $firstNameError,
                        completion: { validateFields(title: .firstName) }
                    )

                    // Last Name
                    FormField(
                        title: localizationService.text(.authLastName),
                        placeholder: localizationService.text(.authLastNamePlaceholder),
                        text: $lastName,
                        error: $lastNameError,
                        completion: { validateFields(title: .lastName) }
                    )

                    // Email
                    FormField(
                        title: localizationService.text(.authEmail),
                        placeholder: "study@email.com",
                        text: $email,
                        keyboardType: .emailAddress,
                        error: $emailError,
                        completion: { validateFields(title: .email) }
                    )

                    // Password
                    FormField(
                        title: localizationService.text(.authPassword),
                        placeholder: localizationService.text(.authPasswordPlaceholder),
                        text: $password,
                        isSecure: true,
                        error: $passwordError,
                        completion: { validateFields(title: .password) }
                    )

                    // Confirm Password
                    FormField(
                        title: localizationService.text(.authConfirmPassword),
                        placeholder: localizationService.text(.authConfirmPasswordPlaceholder),
                        text: $confirmPassword,
                        isSecure: true,
                        error: $confirmPasswordError,
                        completion: { validateFields(title: .confirmPassword) }
                    )

                    // Country Code + Phone Number (side by side)
                    HStack(alignment: .top, spacing: 8) {
                        FormField(
                            title: localizationService.text(.authCountryCode),
                            placeholder: localizationService.text(.authCountryCodePlaceholder),
                            text: $countryCode,
                            keyboardType: .phonePad,
                            error: $countryCodeError,
                            completion: { validateFields(title: .countryCode) }
                        )
                        .frame(maxWidth: 110)

                        FormField(
                            title: localizationService.text(.authContactNumber),
                            placeholder: localizationService.text(.authContactNumberPlaceholder),
                            text: $contactNumber,
                            keyboardType: .numberPad,
                            error: $contactNumberError,
                            completion: { validateFields(title: .contactNumber) }
                        )
                    }

                    // Terms checkbox
                    HStack(alignment: .top) {
                        Toggle(isOn: $agreeToTerms) {
                            Text("")
                        }
                        .toggleStyle(CheckboxToggleStyle())

                        VStack(alignment: .leading, spacing: 5) {
                            Text(localizationService.text(.authAgreeTermsPrefix))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                + Text(localizationService.text(.authAgreeTermsLink))
                                .foregroundColor(.blue)
                                + Text(localizationService.text(.authAgreeTermsSuffix))
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            if let termsError {
                                Text(termsError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.top, 5)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)

                    Spacer()

                    AppButton(
                        title: localizationService.text(.authSignUp),
                        style: .filled,
                        foregroundColor: .white,
                        backgroundColor: .cyan,
                        cornerRadius: 8,
                        font: .system(size: 18, weight: .bold),
                        fullWidth: true,
                        isLoading: isSubmitting,
                        isDisabled: isSubmitting
                    ) {
                        submitSignUp()
                    }
                    .padding()

                    Spacer()
                }
                .navigationTitle(localizationService.text(.authSignUp))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(false)
        .studyAppLoadingOverlay(
            isPresented: isSubmitting,
            symbol: "person.badge.plus",
            tint: .cyan,
            title: localizationService.text(.authCreatingAccountTitle),
            message: localizationService.text(.authCreatingAccountMessage)
        )
        .alert(localizationService.text(.authSignUpFailed), isPresented: $showAuthAlert) {
            Button(localizationService.text(.commonOk), role: .cancel) {}
        } message: {
            Text(authAlertMessage)
        }
    }

    // MARK: - Validation

    func validateAllFields() {
        validateFields(title: .firstName)
        validateFields(title: .lastName)
        validateFields(title: .email)
        validateFields(title: .password)
        validateFields(title: .confirmPassword)
        validateFields(title: .countryCode)
        validateFields(title: .contactNumber)
        validateFields(title: .terms)
    }

    func validateFields(title: Title) {
        switch title {
        case .firstName:
            firstNameError = firstName.trimmingCharacters(in: .whitespaces).isEmpty
                ? localizationService.text(.authEmptyFirstName)
                : nil
        case .lastName:
            lastNameError = lastName.trimmingCharacters(in: .whitespaces).isEmpty
                ? localizationService.text(.authEmptyLastName)
                : nil
        case .email:
            emailError = ValidationHelper.isValidEmail(email)
                ? nil
                : localizationService.text(.authInvalidEmail)
        case .password:
            if password.isEmpty {
                passwordError = localizationService.text(.authEmptyPassword)
            } else if password.count < ValidationHelper.passwordMinLength {
                passwordError = localizationService.text(.authPasswordShort)
            } else if !ValidationHelper.isValidPassword(password) {
                passwordError = localizationService.text(.authPasswordWeak)
            } else {
                passwordError = nil
            }
        case .confirmPassword:
            confirmPasswordError = (password == confirmPassword)
                ? nil
                : localizationService.text(.authConfirmPasswordMismatch)
        case .countryCode:
            countryCodeError = ValidationHelper.isValidCountryCode(countryCode)
                ? nil
                : localizationService.text(.authInvalidCountryCode)
        case .contactNumber:
            contactNumberError = ValidationHelper.isValidContactNumber(contactNumber)
                ? nil
                : localizationService.text(.authInvalidContactNumber)
        case .terms:
            termsError = agreeToTerms ? nil : localizationService.text(.authTermsRequired)
        default:
            break
        }
    }

    // MARK: - Submission

    private func allFieldsValid() -> Bool {
        firstNameError == nil &&
        lastNameError == nil &&
        emailError == nil &&
        passwordError == nil &&
        confirmPasswordError == nil &&
        countryCodeError == nil &&
        contactNumberError == nil &&
        termsError == nil &&
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !countryCode.isEmpty &&
        !contactNumber.isEmpty &&
        agreeToTerms
    }

    private func submitSignUp() {
        validateAllFields()
        guard allFieldsValid(), !isSubmitting else { return }

        isSubmitting = true

        Task {
            do {
                _ = try await authSession.signUp(
                    firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password,
                    confirmPassword: confirmPassword,
                    countryCode: countryCode.trimmingCharacters(in: .whitespacesAndNewlines),
                    contactNumber: contactNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                )

                await MainActor.run {
                    isSubmitting = false
                    popupManager.show(
                        title: localizationService.text(.authAccountCreatedTitle),
                        image: "tickMark",
                        message: localizationService.text(.authAccountCreatedMessage),
                        onPrimary: {
                            popupManager.dismiss()
                            router.push(.signIn)
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

// MARK: - Custom Checkbox Style

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .cyan : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(router: Router<AuthRoute>())
    }
}
