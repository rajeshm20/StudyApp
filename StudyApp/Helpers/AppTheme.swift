//
//  AppTheme.swift
//  StudyApp
//
//  Created by Rajesh Mani on 03/05/25.
//

import Foundation
import UIKit
import SwiftUI

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


struct AppFont {
    static let title = Font.system(size: 24, weight: .bold)
    static let subtitle = Font.system(size: 18, weight: .medium)
    static let body = Font.system(size: 16)
    // Add more as needed
}

extension Color {
    static let brandPrimary = Color("themeColor")
}
