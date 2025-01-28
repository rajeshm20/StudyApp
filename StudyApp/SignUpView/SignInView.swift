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
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Sign In")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.top, 40)
            
            // Email Field
            VStack(alignment: .leading) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Password Field
            VStack(alignment: .leading) {
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Forgot Password
            HStack {
                Spacer()
                Button(action: {
                    // Handle forgot password
                }) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(Color.cyan)
                }
            }
            
            // Login Button
            Button(action: {
                // Handle login action
            }) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            // Sign Up Option
            HStack {
                Text("Don’t have an account?")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Button(action: {
                    // Handle sign-up action
                }) {
                    Text("Sign Up")
                        .font(.footnote)
                        .foregroundColor(Color.cyan)
                }
            }
            
            // OR Divider
            HStack {
                VStack{
                    Color.gray
                }
                .frame(width: 150, height: 1)
                .background(Color.gray.opacity(0.9))
                Text("OR")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                VStack{
                    Color.gray
                }
                .frame(width: 150, height: 1)
                .background(Color.gray.opacity(0.9))
            }
            .padding(.vertical)
            
            // Social Login Buttons
            HStack(spacing: 20) {
                Button(action: {
                    // Handle Google login
                }) {
                    Image("google") // Replace with your Google icon
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                
                Button(action: {
                    // Handle Facebook login
                }) {
                    Image("facebook") // Replace with your Facebook icon
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                
                Button(action: {
                    // Handle Apple login
                }) {
                    Image("apple") // Replace with your Apple icon
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
