//
//  AppTheme.swift
//  StudyApp
//
//  Created by Rajesh Mani on 03/05/25.
//

import Foundation
import SwiftUI
import UIKit

// Theme definition
struct AppTheme {
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    // Add more as needed
}

// Example themes
extension AppTheme {
    static let light = AppTheme(
        primaryColor: .blue,
        secondaryColor: .gray,
        backgroundColor: .white
    )
    static let dark = AppTheme(
        primaryColor: .white,
        secondaryColor: .gray,
        backgroundColor: .black
    )
}

// Theme Manager using ObservableObject
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .light
}

enum AppFont {
    static let title = Font.system(size: 24, weight: .bold)
    static let subtitle = Font.system(size: 18, weight: .medium)
    static let body = Font.system(size: 16)
    // Add more as needed
}

extension Color {
    static let brandPrimary = Color("themeColor")
}

enum AppTheme1: String, CaseIterable, Codable {
    case system
    case light
    case dark
    case cosmic

    var displayName: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        case .cosmic: "Cosmic Purple"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark, .cosmic: .dark
        }
    }

    var accentColor: Color {
        switch self {
        case .system, .light: .blue
        case .dark: .cyan
        case .cosmic: .purple
        }
    }
}

struct ThemeSettings: View {
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme1 = .dark

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(AppTheme1.allCases, id: \.self) { theme in
                        Text(theme.displayName)
                            .tag(theme)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .preferredColorScheme(selectedTheme.colorScheme)
        .accentColor(selectedTheme.accentColor)
    }
}


#Preview {
    ThemeSettings()
}
