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
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            print("❌ Error: countries.json file not found in bundle.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            do {
                let decoded = try JSONDecoder().decode([Language].self, from: data)
                languages = decoded
                print("✅ Successfully loaded \(languages.count) languages.")
            } catch {
                print("❌ JSON decode error:", error)
                // Optionally also log the raw JSON:
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw JSON:", raw)
                }
            }
        } catch {
            print("❌ Failed to load countries.json file data:", error)
        }
    }
}
