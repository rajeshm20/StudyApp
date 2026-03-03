//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//

import Observation
import SwiftUI

enum Title: String {
    case name = "Name"
    case email = "Email"
    case password = "Password"
    case confirmPassword = "Confirm Password"
    case phoneNumber = "Phone number"
    case terms = "Terms"
}

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""
    @State private var agreeToTerms: Bool = false
    // Error states for each field
    @State private var nameError: String? = nil
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil
    @State private var phoneNumberError: String? = nil
    @State private var termsError: String? = nil
    @EnvironmentObject var popupManager: PopupManager
    // Popup visibility
    @State private var showPopup: Bool = false

    // Add this new state variable for navigation
//    @State private var navigateToOTP: Bool = false
    var router: Router<AuthRoute>

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    // Form Fields with Validation Errors
                    FormField(title: "Name",
                              placeholder: "Your name",
                              text: $name,
                              error: $nameError,
                              completion: { validateFields(title: .name) })
                    FormField(title: "Email",
                              placeholder: "study@email.com",
                              text: $email,
                              keyboardType: .emailAddress,
                              error: $emailError,
                              completion: { validateFields(title: .email) })
                    FormField(title: "Password",
                              placeholder: "Your password",
                              text: $password,
                              isSecure: true,
                              error: $passwordError,
                              completion: { validateFields(title: .password) })
                    FormField(title: "Phone Number",
                              placeholder: "0334 xxxx xxxx",
                              text: $phoneNumber,
                              keyboardType: .numberPad,
                              error: $phoneNumberError,
                              isPhoneNumber: true,
                              completion: { validateFields(title: .phoneNumber) })

                    // Terms and Conditions Checkbox
                    HStack(alignment: .top) {
                        Toggle(isOn: $agreeToTerms) {
                            Text("")
                        }
                        .toggleStyle(CheckboxToggleStyle())

                        VStack(alignment: .leading, spacing: 5) {
                            Text("I agree with the")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                + Text(" terms and conditions")
                                .foregroundColor(.blue)
                                + Text(" and also the protection of my personal data on this application")
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

                    // Sign-Up Button (Reusable)
                    AppButton(
                        title: "Sign Up",
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
                    .padding()

                    Spacer()
                }
                .navigationTitle("Sign Up")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .padding(.horizontal)
            }
            .scrollDismissesKeyboard(.interactively)
            // Popup overlay
//                if showPopup {
//                    ZStack {
//                        Color.black.opacity(0.4)
//                            .edgesIgnoringSafeArea(.all)
//                            .onTapGesture {
//                                showPopup = false
//                            }
//
//                        VStack(spacing: 20) {
//                            Image(systemName: "checkmark.circle.fill") // Replace with your custom icon
//                                .font(.system(size: 50))
//                                .foregroundColor(.cyan)
//
//                            Text("Account information is correct?")
//                                .font(.headline)
//                                .fontWeight(.semibold)
//                                .multilineTextAlignment(.center)
//
//                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fames velit.")
//                                .font(.subheadline)
//                                .multilineTextAlignment(.center)
//                                .foregroundColor(.gray)
//
//                            Button(action: {
//                                showPopup = false
//                                router.push(.otp)
//                            }) {
//                                Text("Accept")
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 18, weight: .bold))
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.cyan)
//                                    .cornerRadius(8)
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(radius: 20)
//                        .padding(.horizontal, 20)
//                    }
//                }
        }
        .navigationBarBackButtonHidden(false)
//            .simultaneousGesture(
//                TapGesture().onEnded { self.hideKeyboard() }
//            )
    }

    // Add this new function
    func validateAllFields() {
        validateFields(title: .name)
        validateFields(title: .email)
        validateFields(title: .password)
        validateFields(title: .phoneNumber)
        validateFields(title: .terms)

        // Check if all fields are valid
        let allFieldsValid = nameError == nil &&
            emailError == nil &&
            passwordError == nil &&
            phoneNumberError == nil &&
            termsError == nil &&
            !name.isEmpty &&
            !email.isEmpty &&
            !password.isEmpty &&
            !phoneNumber.isEmpty &&
            agreeToTerms

        if allFieldsValid {
            popupManager.show(
                title: "Account information is correct?",
                image: "SucessTick",
                message: "Tap accept button to confirm entered details are correct.",
                onClose: {
                    // Dynamic navigation or any logic goes here:
                    router.push(.otp)
                    popupManager.isVisible = false // Also dismiss the popup
                }
            )
        }
    }

    // Modify the existing validateFields function
    func validateFields(title: Title) {
        switch title {
        case .name:
            nameError = name.isEmpty ? "Name cannot be empty" : nil
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
        case .phoneNumber:
            phoneNumberError = ValidationHelper.isValidPhoneNumber(phoneNumber) ? nil : "Please enter a valid phone number"
        case .terms:
            termsError = agreeToTerms ? nil : "You must agree to the terms"
        default:
            break
        }
        // Remove the automatic popup showing logic from here
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
