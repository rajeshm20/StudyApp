//
//  SignUpView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//
// Fix errors in this below entire code
// fix compile time errors.

import SwiftUI

enum Title: String {
    case name = "Name"
    case email =  "Email"
    case password = "Password"
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
    
    // Popup visibility
    @State private var showPopup: Bool = false

    // Add this new state variable for navigation
    @State private var navigateToOTP: Bool = false

    var body: some View {
        NavigationStack {  // Wrap the main content in NavigationStack
            ZStack {
                ScrollView {
                    VStack {
                        // Navigation Bar
                        HStack {
                            Spacer()
                            Text("Sign up")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding()
                        // Form Fields with Validation Errors
                        FormField(title: "Name", placeholder: "Your name", text: $name, error: $nameError, completion: { self.validateFields(title: .name) })
                        FormField(title: "Email", placeholder: "study@email.com", text: $email, keyboardType: .emailAddress, error: $emailError, completion: { self.validateFields(title: .email) })
                        FormField(title: "Password", placeholder: "Your password", text: $password, isSecure: true, error: $passwordError, completion: { self.validateFields(title:.password) })
                        FormField(title: "Phone Number", placeholder: "0334 xxxx xxxx", text: $phoneNumber, keyboardType: .numberPad, error: $phoneNumberError, isPhoneNumber: true, completion: { self.validateFields(title: .phoneNumber) })

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
                                
                                if let termsError = termsError {
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

                        // Sign-Up Button
                        Button(action: {
                            validateAllFields()
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .cornerRadius(8)
                        }
                        .padding()

                        Spacer()
                    }
                    .padding(.horizontal)
                }

                // Popup overlay
                if showPopup {
                    ZStack {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showPopup = false
                            }
                        
                        VStack(spacing: 20) {
                            Image(systemName: "checkmark.circle.fill") // Replace with your custom icon
                                .font(.system(size: 50))
                                .foregroundColor(.cyan)

                            Text("Account information is correct?")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)

                            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fames velit.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)

                            Button(action: {
                                showPopup = false
                                navigateToOTP = true  // Trigger navigation
                            }) {
                                Text("Accept")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 20)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToOTP) {
                OTPVerificationView()
            }
        }
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
            showPopup = true
        }
    }

    // Modify the existing validateFields function
    func validateFields(title: Title) {
        switch title {
        case .name:
            nameError = name.isEmpty ? "Name cannot be empty" : nil
        case .email:
            emailError = isValidEmail(email) ? nil : "Please enter a valid email"
        case .password:
            if password.isEmpty {
                passwordError = "Password cannot be empty"
            } else if password.count < 6 {
                passwordError = "Password must be at least 6 characters"
            } else if !isValidPassword(password) {
                passwordError = "Password must contain both letters and numbers"
            } else {
                passwordError = nil
            }
        case .phoneNumber:
            phoneNumberError = isValidPhoneNumber(phoneNumber) ? nil : "Please enter a valid phone number"
        case .terms:
            termsError = agreeToTerms ? nil : "You must agree to the terms"
        }
        // Remove the automatic popup showing logic from here
    }

    // Email validation function
    func isValidEmail(_ email: String) -> Bool {
        // Simple email validation (you can make it more complex)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    // Phone number validation function
    func isValidPhoneNumber(_ number: String) -> Bool {
        // Updated regex to ensure exactly 12 digits with proper spacing
        let phoneRegex = "^\\d{4} \\d{4} \\d{4}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePred.evaluate(with: number)
    }

    // Add this new password validation function
    func isValidPassword(_ password: String) -> Bool {
        let hasLetters = password.contains { $0.isLetter }
        let hasNumbers = password.contains { $0.isNumber }
        return hasLetters && hasNumbers
    }

}

// MARK: - Reusable Form Field View with Validation
struct FormField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    @Binding var error: String?
    var isPhoneNumber: Bool = false
    var completion: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            if isSecure {
                SecureField(placeholder, text: $text, onCommit: {
                    completion()
                })
                .onChange(of: text) {
                    completion()
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)) // Border
                .cornerRadius(8)
            } else {
                TextField(placeholder, text: $text, onCommit: {
                    completion()
                })
                .onChange(of: text) { oldValue, newValue in
                    if isPhoneNumber {
                        text = formatPhoneNumber(newValue)
                    }
                    completion()
                }
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .sentences)
                .padding()
                .background(Color.gray.opacity(0.1))
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)) // Border
                .cornerRadius(8)
            }

            // Display validation error if exists
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 5)
            }
        }
        .padding(.vertical, 5)
        
    }
    
    func formatPhoneNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        // Limit to 12 digits (4+4+4)
        let truncatedDigits = String(digits.prefix(12))
        
        var formatted = ""
        for (index, digit) in truncatedDigits.enumerated() {
            if index == 4 || index == 8 {
                formatted += " "
            }
            formatted += String(digit)
        }
        return formatted
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
        SignUpView()
    }
}
