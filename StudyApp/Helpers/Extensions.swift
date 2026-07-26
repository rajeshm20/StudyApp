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
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
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

// MARK: Convert the Swift model to JSON data.

extension Encodable {
    func toJSON() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: Modern Navigation (iOS 16+)

// usage: .navigate(isPresented: $goToNextScreen) { NextView() }
// Must be inside a NavigationStack
extension View {
    /// Presents a destination view programmatically when the binding is set to true.
    /// Should be used inside a NavigationStack.
    func navigate(
        isPresented: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> some View
    ) -> some View {
        navigationDestination(isPresented: isPresented, destination: destination)
    }
}

extension Text {
    func titleStyle() -> some View {
        font(.system(size: 26, weight: .bold))
            .foregroundColor(.appTextPrimary)
    }

    func subtitleStyle() -> some View {
        font(.system(size: 18, weight: .medium))
            .foregroundColor(.appTextSecondary)
    }

    func captionStyle() -> some View {
        font(.footnote)
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
        padding()
            .frame(maxWidth: .infinity)
            .background(Color.cyan)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    func secondaryButtonStyle() -> some View {
        padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct StudyAppLoadingOverlay: View {
    let symbol: String
    let tint: Color
    let title: String
    let message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.14))
                        .frame(width: 78, height: 78)

                    Circle()
                        .stroke(tint.opacity(0.22), lineWidth: 1)
                        .frame(width: 92, height: 92)

                    Image(systemName: symbol)
                        .font(.system(size: 30, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(tint)
                        .symbolEffect(.pulse.byLayer, options: .repeating)
                }

                VStack(spacing: 6) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                ProgressView()
                    .tint(tint)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 22)
            .frame(maxWidth: 300)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(tint.opacity(0.14), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 14, x: 0, y: 8)
            .padding(.horizontal, 24)
        }
    }
}

private struct StudyAppLoadingOverlayModifier: ViewModifier {
    let isPresented: Bool
    let symbol: String
    let tint: Color
    let title: String
    let message: String

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    StudyAppLoadingOverlay(
                        symbol: symbol,
                        tint: tint,
                        title: title,
                        message: message
                    )
                }
            }
    }
}

extension View {
    func studyAppLoadingOverlay(
        isPresented: Bool,
        symbol: String = "arrow.triangle.2.circlepath",
        tint: Color = .brandPrimary,
        title: String,
        message: String
    ) -> some View {
        modifier(
            StudyAppLoadingOverlayModifier(
                isPresented: isPresented,
                symbol: symbol,
                tint: tint,
                title: title,
                message: message
            )
        )
    }
}

// MARK: Fonts Extension

// Centralise font definitions with a Font extension:
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

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
