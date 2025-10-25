//
//  Language.swift
//  StudyApp
//
//  Created by Rajesh Mani on 23/10/25.
//


import Foundation
import SwiftUI

struct Language: Identifiable, Codable {
    let id = UUID()
    let name: String
    let code: String

    var flagEmoji: String {
        code.unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}

@MainActor
class LanguageViewModel: ObservableObject {
    @Published var languages: [Language] = []
    @Published var searchText: String = ""
    @Published var selectedLanguage: Language?

    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return languages
        } else {
            return languages.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func loadLanguages() {
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Language].self, from: data) {
            languages = decoded
        }
    }
}
