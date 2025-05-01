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
}


extension Serializable where Self: Encodable {
    func serialize() -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }
}


// MARK: Example

struct User: Serializable, Encodable {
    let id: Int
    let name: String
}

let user = User(id: 1, name: "Alice")
//print(user.serialize())  // Prints: {"id":1,"name":"Alice"}



protocol Stylable {
    func applyStyle()
}

extension Stylable where Self: UILabel {
    func applyStyle() {
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .gray
    }
}

extension UILabel: Stylable { }

let label = UILabel()
//label.applyStyle()
