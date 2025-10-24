//
//  Language.swift
//  StudyApp
//
//  Created by Rajesh Mani on 23/10/25.
//


import Foundation

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