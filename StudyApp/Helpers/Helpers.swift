//
//  Helpers.swift
//  StudyApp
//
//  Created by Rajesh Mani on 30/03/25.
//

import Foundation
import UIKit
import SwiftUI

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
//    .gesture(
//        DragGesture()
//            .onEnded { value in
//                // Manual velocity calculation
//                let deltaX = value.location.x - value.startLocation.x
//                let deltaY = value.location.y - value.startLocation.y
//                let duration = value.time.timeIntervalSince(value.startTime)
//                let velocityX = deltaX / duration
//                let velocityY = deltaY / duration
//                print("Velocity: \(velocityX), \(velocityY)")
//            }
//    )
//After SwiftUI 2025:
//    .gesture(
//        DragGesture()
//            .onEnded { value in
//                let velocity = value.velocity
//                print("Velocity: \(velocity.width), \(velocity.height)")
//            }
//    )

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


struct BorderedButton<Content: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Content
    var buttonWithStrok: Bool = true
    var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding()
                .foregroundColor(.white)
                .cornerRadius(8)
                .overlay {
                    if buttonWithStrok {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .foregroundStyle(.buttoncolor)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                }
          }
    }
}
