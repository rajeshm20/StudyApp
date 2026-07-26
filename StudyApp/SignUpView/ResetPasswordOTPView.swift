    //
    //  ResetPasswordOTPView.swift
    //  StudyApp
    //
    //  Created by Rajesh Mani on 24/07/26.
    //

import SwiftUI

struct ResetPasswordOTPView: View {
    @State private var otp: String = ""
    @State private var otpError: String? = nil
    @EnvironmentObject var popupManager: PopupManager
    @State private var authAlertMessage = ""
    @State private var showAuthAlert = false
    @State private var isSubmitting = false
    @EnvironmentObject var authSession: AuthSessionManager
    @Environment(\.dismiss) private var dismiss

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
            FormField(title: "OTP", placeholder: "Enter 6 digit OTP", text: $otp, keyboardType: .numberPad, error: $otpError, completion: {
                validateFields(title: .otp)
            })
            .padding(10)
            
                // Sign-In Button (Reusable)
            AppButton(
                title: "Verify OTP",
                style: .filled,
                foregroundColor: .white,
                backgroundColor: .cyan,
                cornerRadius: 8,
                font: .system(size: 18, weight: .bold),
                fullWidth: true,
                isLoading: isSubmitting,
                isDisabled: isSubmitting
            ) {
                verifyOTP()
            }
            .padding(.horizontal)
        }
        .padding()
        .studyAppLoadingOverlay(
            isPresented: isSubmitting,
            symbol: "number.circle",
            tint: .cyan,
            title: "Verifying OTP",
            message: "Confirming the one-time code from your email."
        )
        .alert("OTP Verification Failed", isPresented: $showAuthAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authAlertMessage)
        }
        
        Spacer()
    }
    
        // Add this new function
    func verifyOTP() {
        validateFields(title: .otp)
        
            // Check if otp field valid
        guard otpError == nil else { return }
        guard !isSubmitting else { return }
        isSubmitting = true

        Task {
            do {
                let response = try await authSession.VerifyOTP(
                    otp: otp
                )
                await MainActor.run {
                    isSubmitting = false
                    popupManager.show(
                        title: response.success ? "OTP Successfully Verified" : response.message,
                        image: response.success ? "tick_round" : "invalid",
                        message: response.success ? "Tap to reset your password" : "Enter correct OTP",
                        onPrimary: {
                            popupManager.dismiss()
                            response.success ? router.push(.resetPassword) : ()
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
    
        // Modify the existing validateFields function
    func validateFields(title: Title) {
        switch title {
            case .otp:
                otpError = ValidationHelper
                    .isValidOTP(otp) ? nil : "Please enter correct 6 digit OTP received in your registered email"
            default:
                break
        }
    }
}

#Preview {
    ResetPasswordOTPView(router: Router<AuthRoute>())
}
