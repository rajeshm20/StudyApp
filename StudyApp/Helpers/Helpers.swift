//
//  Helpers.swift
//  StudyApp
//
//  Created by Rajesh Mani on 30/03/25.
//

import Foundation
import UIKit

protocol Serializable {
    func serialize() -> String
    func deserialize(_ json: String) -> Self
}


extension Serializable where Self: Codable {
    func serialize() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }
    func deserialize(_ json: String) -> Self {
        let decoder = JSONDecoder()
        guard let data = json.data(using: .utf8) else {
            fatalError("Invalid JSON string")
        }
        return try! decoder.decode(Self.self, from: data)
    }
}


// MARK: Example

struct User: Serializable, Codable {
    let id: Int
    let name: String
}

let user = User(id: 1, name: "Alice")
//print(user.serialize())  // Prints: {"id":1,"name":"Alice"}



protocol Stylable {
    func applyStyle() async
}

extension Stylable where Self: UILabel {
    @MainActor func applyStyle() {
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .gray
    }
}

extension UILabel: Stylable { }

@MainActor let label = UILabel()
//label.applyStyle()
