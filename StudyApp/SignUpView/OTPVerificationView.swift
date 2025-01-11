//
//  OTPView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//

import SwiftUI
import Combine

//MARK: - Fix below code to implement OTP Verification View
struct OTPVerificationView: View {
    @State private var otpFields: [String] = Array(repeating: "", count: 4) // Array to store 4 digits
    @FocusState private var focusedField: Int? // To manage field focus
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [.cyan, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 100)
                
                // OTP Input Fields
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { index in
                        TextField("", text: Binding(
                            get: { otpFields[index] },
                            set: { newValue in
                                // Handle deletion
                                if newValue.isEmpty {
                                    otpFields[index] = ""
                                    if index > 0 {
                                        DispatchQueue.main.async {
                                            focusedField = index - 1
                                        }
                                    }
                                    return
                                }
                                
                                // Only take the last character if multiple characters are entered
                                let lastChar = String(newValue.last ?? " ")
                                
                                // Only allow single numeric input
                                if lastChar.rangeOfCharacter(from: .decimalDigits) != nil {
                                    otpFields[index] = lastChar
                                    
                                    // Move to next field after entering a number
                                    if index < 3 {
                                        DispatchQueue.main.async {
                                            focusedField = index + 1
                                        }
                                    }
                                }
                            }
                        ))
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(29)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: index)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Buttons for Verify and Resend
                VStack(spacing: 20) {
                    Button(action: verifyOTP) {
                        Text("Verify")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Button(action: resendOTP) {
                        Text("Resend OTP")
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
    
    // OTP Verification function
    private func verifyOTP() {
        let otpCode = otpFields.joined()
        print("Entered OTP is: \(otpCode)")
        // Implement your verification logic here
    }
    
    // Resend OTP function
    private func resendOTP() {
        print("Resending OTP")
        otpFields = Array(repeating: "", count: 4) // Clear the fields
        focusedField = 0 // Focus back on the first field
    }
}

// MARK: - Preview
struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView()
    }
}
