// MARK: - 1. Profile Data Model & Utility

import SwiftUI

enum AccountViewTitles: String {
    case oldPassword = "Old Password"
    case newPassword =  "New Password"
    case confirmPassword = "Confirm Password"
}

struct AccountView: View {
    // State to hold the profile data and manage the view's state
    @State private var profile = Profile()
    @State private var alertMessage = ""
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    // Per-field error state to satisfy FormField(error: Binding<String?>)
    @State private var oldPasswordError: String? = nil
    @State private var newPasswordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @EnvironmentObject var popupManager: PopupManager
    var router:Router<MainRoute>

    // Computed property for form validation
    var isFormValid: Bool {
        // Name must not be empty
        guard oldPassword.count != 0, newPassword.count != 0, confirmPassword.count != 0 else {
            return false
        }
        guard oldPasswordError == nil, newPasswordError == nil, confirmPasswordError == nil else {
            return false
        }
        // If all checks pass
        return true
    }

    var body: some View {
        // Use a ZStack to layer the navigation bar content over the scroll view
            ZStack(alignment: .top) {
                // White background for the form
                Color.white.edgesIgnoringSafeArea(.all)
                
                // Outer blue border/background color from the image
                VStack {
                    Spacer()
                    // A blue frame to mimic the light-blue container background from the image
                    Color(red: 0.9, green: 0.95, blue: 1.0)
                        .frame(height: 100)
                }
                .edgesIgnoringSafeArea(.bottom)
                
                VStack(spacing: 0) {
                    // MARK: Scrollable Form Content
                    ScrollView {
                        VStack(spacing: 15) {
                            // MARK: Form Fields
                            Spacer()
                            FormField(title: "Old Password", placeholder: "Your password", text: $oldPassword, isSecure: true, error: $oldPasswordError, completion: {
                                self.validateFields(title:.oldPassword)
                            })
                            FormField(title: "New Password", placeholder: "New password", text: $newPassword, isSecure: true, error: $newPasswordError, completion: {
                                self.validateFields(title:.newPassword)
                            })
                            FormField(title: "Confirm Password", placeholder: "Confirm password", text: $confirmPassword, isSecure: true, error: $confirmPasswordError, completion: {
                                self.validateFields(title:.confirmPassword)
                            })
                            Spacer()
                            // MARK: Update Button
                            AppButton(
                                title: "Update Password",
                                style: .filled,
                                foregroundColor: .white,
                                backgroundColor: .cyan,
                                cornerRadius: 8,
                                font: .system(size: 18, weight: .bold),
                                fullWidth: true,
                                isLoading: false,
                                isDisabled: false
                            ) {
                                if isFormValid {
                                    // Logic to save/update profile goes here
                                    alertMessage = "Password updated successfully!"
                                    popupManager.show(
                                        title: "Password Updated",
                                        image: "key",
                                        message: alertMessage,
                                        onClose: {
                                            // Dynamic navigation or any logic goes here:
                                            router.pop()
                                            popupManager.isVisible = false // Also dismiss the popup
                                        }
                                    )

                                    self.hideKeyboard()
                                } else {
                                    validateFields(title: .oldPassword)
                                    validateFields(title: .newPassword)
                                    validateFields(title: .confirmPassword)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                        .padding(.horizontal, 25) // Horizontal padding for the form content
                    }
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        // Keyboard dismiss gesture for entire screen
            .simultaneousGesture(
                TapGesture().onEnded { self.hideKeyboard() }
            )

    }
    // Modify the existing validateFields function
    func validateFields(title: AccountViewTitles) {
        switch title {
        case .oldPassword:
            if oldPassword.isEmpty {
                oldPasswordError = "Old Password cannot be empty"
            } else if oldPassword.count < 6 {
                oldPasswordError = "Old Password must be at least 6 characters"
            } else if !ValidationHelper.isValidPassword(oldPassword) {
                oldPasswordError = "Old Password must contain both letters and numbers"
            } else {
                oldPasswordError = nil
            }
        case .newPassword:
            if newPassword.isEmpty {
                newPasswordError = "New Password cannot be empty"
            } else if newPassword.count < 6 {
                newPasswordError = "New Password must be at least 6 characters"
            } else if !ValidationHelper.isValidPassword(newPassword) {
                newPasswordError = "New Password must contain both letters and numbers"
            } else {
                newPasswordError = nil
            }
        case .confirmPassword:
            if confirmPassword.isEmpty {
                confirmPasswordError = "Confirm Password cannot be empty"
            } else if confirmPassword.count < 6 {
                confirmPasswordError = "Confirm Password must be at least 6 characters"
            } else if !ValidationHelper.isValidPassword(confirmPassword) {
                confirmPasswordError = "Confirm Password must contain both letters and numbers"
            } else if confirmPassword != newPassword {
                confirmPasswordError = "Passwords do not match"
            } else {
                confirmPasswordError = nil
            }
        }
    }

}

// MARK: - Preview
struct AccountVieww_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(router: Router<MainRoute>())
    }
}
