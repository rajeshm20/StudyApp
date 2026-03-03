//
//  NewSignupView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/01/25.
//

import SwiftUI

struct VerificationCodeView: View {
    @State private var code: [String] = ["", "", "", ""]
    @FocusState private var focusedIndex: Int?

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
                ForEach(0 ..< 4, id: \.self) { index in
                    TextField("", text: $code[index])
                        .frame(width: 60, height: 60)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusedIndex, equals: index)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(focusedIndex == index ? Color.white : Color.clear, lineWidth: 2)
                        )
                        .cornerRadius(40)
                        .onChange(of: code[index]) { newValue in
                            if newValue.count == 1 {
                                if index < 3 {
                                    focusedIndex = index + 1
                                } else {
                                    focusedIndex = nil
                                }
                            } else if newValue.count > 1 {
                                code[index] = String(newValue.prefix(1))
                            }
                        }
                }
            }
            .padding(.top, 40)
            Spacer()
            // Verify Button
            Button(action: {
                // Handle verification logic
            }) {
                Text("Verify")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
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
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView()
    }
}
