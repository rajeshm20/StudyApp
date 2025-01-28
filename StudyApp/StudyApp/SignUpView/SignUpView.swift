//
//  SignUpView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//

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

    var body: some View {
        ScrollView {
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Action for back button
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Sign up")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    // Placeholder for symmetrical padding
                    Image(systemName: "arrow.left")
                        .opacity(0)
                }
                .padding()

                // Form Fields with Validation Errors
                FormField(title: "Name", placeholder: "Your name", text: $name, error: $nameError, completion: { self.validateFields(title: "Name") })
                FormField(title: "Email", placeholder: "study@email.com", text: $email, keyboardType: .emailAddress, error: $emailError, completion: { self.validateFields(title: "Email") })
                FormField(title: "Password", placeholder: "Your password", text: $password, isSecure: true, error: $passwordError, completion: { self.validateFields(title: "Password") })
                FormField(title: "Phone Number", placeholder: "0334 xxxx xxxx", text: $phoneNumber, keyboardType: .numberPad, error: $phoneNumberError, completion: { self.validateFields(title: "Phone Number") })

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
                    validateFields()
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

            // Popup View
            if showPopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
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
                        // Accept action
                        showPopup = false
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

    // Validation logic
    func validateFields(title: String) {
        switch title {
        case: "Name"
            nameError = name.isEmpty ? "Name cannot be empty" : nil
        case: "Email"
            emailError = isValidEmail(email) ? nil : "Please enter a valid email"
        case : "password"
            passwordError = password.isEmpty ? "Password cannot be empty" : nil
        case : "Phone number"
            phoneNumberError = isValidPhoneNumber(phoneNumber) ? nil : "Please enter a valid phone number"
        case : "Terms"
            
        default:
            return
        }        termsError = agreeToTerms ? nil : "You must agree to the terms"

        // Show popup if there are no errors
        if nameError == nil && emailError == nil && passwordError == nil && phoneNumberError == nil && termsError == nil {
            showPopup = true
        }
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
        let phoneRegex = "^[0-9]{4} [0-9]{4} [0-9]{4}$" // Regex for "0334 xxxx xxxx"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePred.evaluate(with: number)
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
    var completion: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            if isSecure {
                SecureField(placeholder, text: $text,  onCommit: {
                    onEdtChnged(false)
                })
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.5)) // Border
                    .cornerRadius(8)
            } else {
                TextField(placeholder, text: $text, onCommit: {
                    onEdtChnged(true)
                })
                    .keyboardType(keyboardType)
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
    
    private func onEdtChnged(_ editingEnded: Bool) {
            // Handle editing ended
            if editingEnded {
                print("Editing ended")
                completion()
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
        SignUpView()
    }
}

//struct SignUpView: View {
//    @State private var name: String = ""
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var phoneNumber: String = ""
//    @State private var agreeToTerms: Bool = false
//
//    // Error states for each field
//    @State private var nameError: String? = nil
//    @State private var emailError: String? = nil
//    @State private var passwordError: String? = nil
//    @State private var phoneNumberError: String? = nil
//    @State private var termsError: String? = nil
//
//    var body: some View {
//        VStack {
//            // Navigation Bar
//            HStack {
//                Button(action: {
//                    // Action for back button
//                }) {
//                    Image(systemName: "arrow.left")
//                        .foregroundColor(.black)
//                }
//                Spacer()
//                Text("Sign up")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                Spacer()
//                // Placeholder for symmetrical padding
//                Image(systemName: "arrow.left")
//                    .opacity(0)
//            }
//            .padding()
//
//            // Form Fields with Validation Errors
//            FormField(
//                title: "Name",
//                placeholder: "Your name",
//                text: $name,
//                error: $nameError
//            )
//            FormField(
//                title: "Email",
//                placeholder: "study@email.com",
//                text: $email,
//                keyboardType: .emailAddress,
//                error: $emailError
//            )
//            FormField(
//                title: "Password",
//                placeholder: "Your password",
//                text: $password,
//                isSecure: true,
//                error: $passwordError
//            )
//            FormField(
//                title: "Phone Number",
//                placeholder: "0334 xxxx xxxx",
//                text: $phoneNumber,
//                keyboardType: .numberPad,
//                error: $phoneNumberError
//            )
//
//            // Terms and Conditions Checkbox
//            HStack(alignment: .top) {
//                Toggle(isOn: $agreeToTerms) {
//                    Text("")
//                }
//                .toggleStyle(CheckboxToggleStyle())
//
//                VStack(alignment: .leading, spacing: 5) {
//                    Text("I agree with the")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    + Text(" terms and conditions")
//                        .foregroundColor(.blue)
//                        .underline()
//                    + Text(" and also the protection of my personal data on this application")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//
//                    if let termsError = termsError {
//                        Text(termsError)
//                            .foregroundColor(.red)
//                            .font(.caption)
//                            .padding(.top, 5)
//                    }
//                }
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 10)
//
//            Spacer()
//
//            // Sign-Up Button
//            Button(action: {
//                validateFields()
//            }) {
//                Text("Sign Up")
//                    .foregroundColor(.white)
//                    .font(.system(size: 18, weight: .bold))
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.cyan)
//                    .cornerRadius(8)
//            }
//            .padding()
//
//            Spacer()
//        }
//        .padding(.horizontal)
//    }
//
//    // Validation logic
//    func validateFields() {
//        nameError = name.isEmpty ? "Name cannot be empty" : nil
//        emailError = isValidEmail(email) ? nil : "Please enter a valid email"
//        passwordError = password.isEmpty ? "Password cannot be empty" : nil
//        phoneNumberError = isValidPhoneNumber(phoneNumber) ? nil : "Please enter a valid phone number"
//        termsError = agreeToTerms ? nil : "You must agree to the terms"
//    }
//
//    // Email validation function
//    func isValidEmail(_ email: String) -> Bool {
//        // Simple email validation (you can make it more complex)
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
//    }
//
//    // Phone number validation function
//    func isValidPhoneNumber(_ number: String) -> Bool {
//        let phoneRegex = "^[0-9]{4} [0-9]{4} [0-9]{4}$" // Regex for "0334 xxxx xxxx"
//        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        return phonePred.evaluate(with: number)
//    }
//}
//
//// MARK: - Reusable Form Field View with Validation
//struct FormField: View {
//    var title: String
//    var placeholder: String
//    @Binding var text: String
//    var isSecure: Bool = false
//    var keyboardType: UIKeyboardType = .default
//    @Binding var error: String?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(title)
//                .font(.subheadline)
//                .fontWeight(.semibold)
//                .foregroundColor(.black)
//
//            if isSecure {
//                SecureField(placeholder, text: $text)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .overlay {
//
//                    }
//            } else {
//                TextField(placeholder, text: $text)
//                    .keyboardType(keyboardType)
//                    .padding()
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .overlay {
//
//                    }
//            }
//
//            // Display validation error if exists
//            if let error = error {
//                Text(error)
//                    .foregroundColor(.red)
//                    .font(.caption)
//                    .padding(.top, 5)
//                    .overlay {
//
//                    }
//
//            }
//        }
//        .padding(.vertical, 5)
//    }
//}
//
//// MARK: - Custom Checkbox Style
//struct CheckboxToggleStyle: ToggleStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        Button(action: {
//            configuration.isOn.toggle()
//        }) {
//            HStack {
//                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
//                    .foregroundColor(configuration.isOn ? .blue : .gray)
//            }
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// MARK: - Preview
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
