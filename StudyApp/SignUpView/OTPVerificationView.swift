//
//  OTPView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/09/24.
//

import SwiftUI
import Combine

struct OTPVerificationView: View {
    @State private var code: [String] = ["", "", "", ""]
    @FocusState private var focusedIndex: Int?
    @State private var navigateToLogin: Bool = false
    @State private var enableVerifyBtn: Bool = false
    var router: Router<AuthRoute>
    var body: some View {
        VStack {
            // Header
            Text("Verification Code")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            Text("Enter the code sent by SMS to verify your phone number")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 8)
            
            // OTP Input Fields
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { index in
                    ZStack {
                        // Background with conditional border
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white.opacity(0.2))
                        
                        // Active border
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white, lineWidth: 2)
                            .opacity(focusedIndex == index ? 1 : 0)
                        
                        TextField("", text: $code[index])
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusedIndex, equals: index)
                            .onChange(of: code[index]) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                
                                // Update field with filtered value if it changed
                                if filtered != newValue {
                                    code[index] = filtered
                                }
                                
                                if filtered.count == 1 {
                                    if index < 3 {
                                        focusedIndex = index + 1
                                    } else {
                                        enableVerifyBtn = true
                                        focusedIndex = nil
                                    }
                                } else if filtered.count > 1 {
                                    code[index] = String(filtered.prefix(1))
                                } else if filtered.isEmpty {
                                    // Handle backspace
                                    if index > 0 {
                                        focusedIndex = index - 1
                                        enableVerifyBtn = false
                                    }
                                }
                            }
                    }
                    .frame(width: 60, height: 60)
                }
            }
            .padding(.top, 40)
            Spacer()
            // Verify Button
            Button(action: {
                // Handle verification logic
                if enableVerifyBtn {
                    router.push(.userOnboard)
                }
            }) {
                Text("Verify")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(enableVerifyBtn == true ? Color.white : Color.white.opacity(0.5))
                    .cornerRadius(10)
            }
            .disabled(!enableVerifyBtn)
            .padding(.horizontal)
            .padding(.top, 40)
            
            // Resend Code
            Button(action: {
                // Handle resend code logic
            }) {
                Text("Resend Code")
                    .font(.body)
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
            
        }
        .navigationBarBackButtonHidden(true)
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
        )
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(router: Router<AuthRoute>())
    }
}
