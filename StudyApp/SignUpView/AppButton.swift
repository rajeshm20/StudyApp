//
//  AppButton.swift
//  StudyApp
//
//  Created by Rajesh Mani on 19/10/25.
//

import SwiftUI

enum AppButtonStyleKind {
    case filled
    case outline
    case plain
}

struct AppButton: View {
    let title: String
    var style: AppButtonStyleKind = .filled
    var foregroundColor: Color? = nil
    var backgroundColor: Color? = nil
    var cornerRadius: CGFloat = 8
    var font: Font = .system(size: 18, weight: .bold)
    var fullWidth: Bool = true
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var leadingIcon: String? = nil
    var trailingIcon: String? = nil
    let action: () -> Void

    private var resolvedBackground: Color {
        switch style {
        case .filled:
            return (backgroundColor ?? .cyan)
        case .outline, .plain:
            return .clear
        }
    }

    private var resolvedForeground: Color {
        switch style {
        case .filled:
            return (foregroundColor ?? .white)
        case .outline:
            return (foregroundColor ?? .cyan)
        case .plain:
            return (foregroundColor ?? .accentColor)
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline:
            return backgroundColor ?? .cyan
        default:
            return .clear
        }
    }

    var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(resolvedForeground)
                } else {
                    if let leading = leadingIcon {
                        Image(systemName: leading)
                    }
                    Text(title)
                    if let trailing = trailingIcon {
                        Image(systemName: trailing)
                    }
                }
            }
            .font(font)
            .foregroundColor(resolvedForeground)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding()
            .background(resolvedBackground)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: style == .outline ? 1.5 : 0)
            )
            .cornerRadius(cornerRadius)
            .opacity((isDisabled || isLoading) ? 0.7 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(title)
    }
}

#Preview {
    VStack(spacing: 16) {
        AppButton(title: "Primary", style: .filled, backgroundColor: .cyan) {}
        AppButton(title: "Outline", style: .outline, backgroundColor: .cyan) {}
        AppButton(title: "Loading", isLoading: true) {}
        AppButton(title: "Disabled", isDisabled: true) {}
        AppButton(title: "With Icon", leadingIcon: "checkmark.circle.fill") {}
    }
    .padding()
}
