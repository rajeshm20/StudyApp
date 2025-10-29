//
//  Extensions.swift
//  StudyApp
//
//  Created by Rajesh Mani on 23/10/25.
//

import Foundation
import SwiftUI

struct DemoView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var goToNextScreen = false
    private var isHighlighted = true

    var body: some View {
        NavigationStack { // wrap in NavigationStack to use .navigationDestination
            ScrollView {
                VStack(spacing: 40) {
                    Text("Welcome Back").titleStyle()
                    Text("Please sign in").subtitleStyle()
                    Text("Sign In is required")
                        .if(isHighlighted) { $0.foregroundColor(.red) }

                    TextField("Email", text: $email)
                        .roundedTextFieldStyle(backgroundColor: .yellow.opacity(0.1))

                    SecureField("Password", text: $password)
                        .roundedTextFieldStyle()

                    Button("Tap here to Sign In") {
                        hideKeyboard()
                    }.primaryButtonStyle()

                    Button("Move to Next Screen") {
                        goToNextScreen = true
                    }.secondaryButtonStyle()

                    Spacer()
                    Text("copyright @iOS Coding 2025").captionStyle()
                }
            }
            .padding()
            .navigate(isPresented: $goToNextScreen) {
                EmptyView()
            }
        }
    }
}

#Preview {
    DemoView()
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: Card Style
extension View {
    func cardStyle(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: Hide keyboard
/* usage:
 Button("Tap here to Sign In") {
 hideKeyboard()
 }.primaryButtonStyle()
*/
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

// MARK: Modern Navigation (iOS 16+)
// usage: .navigate(isPresented: $goToNextScreen) { NextView() }
// Must be inside a NavigationStack
extension View {
    /// Presents a destination view programmatically when the binding is set to true.
    /// Should be used inside a NavigationStack.
    func navigate<Destination: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        self
            .navigationDestination(isPresented: isPresented, destination: destination)
    }
}

extension Text {
   func titleStyle() -> some View {
        self
            .font(.system(size: 26, weight: .bold))
            .foregroundColor(.appTextPrimary)
    }

    func subtitleStyle() -> some View {
        self
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.appTextSecondary)
    }

    func captionStyle() -> some View {
        self
            .font(.footnote)
            .foregroundColor(.appTextSecondary)
    }
}

extension View {
    func roundedTextFieldStyle(
        backgroundColor: Color = .white,
        borderColor: Color = .gray.opacity(0.7),
        cornerRadius: CGFloat = 10,
        padding: CGFloat = 12
    ) -> some View {
        self
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}


extension View {
    func primaryButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.cyan)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    func secondaryButtonStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}


// MARK: Fonts Extension
//Centralise font definitions with a Font extension:
// Usage:
// Text("Welcome").font(.appTitle)

extension Font {
    static let appTitle = Font.system(size: 24, weight: .bold, design: .rounded)
    static let appBody = Font.system(size: 16, weight: .regular, design: .default)
    static let appCaption = Font.system(size: 12, weight: .light, design: .default)
}


import SwiftUI

extension Color {
    var isDark: Bool {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var white: CGFloat = 0
        uiColor.getWhite(&white, alpha: nil)
        if white < 0.001 || white > 0.999 {
            var brightness: CGFloat = 0
            uiColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
            return brightness < 0.7
        }
        return white < 0.7
        #else
        return false
        #endif
    }
}
