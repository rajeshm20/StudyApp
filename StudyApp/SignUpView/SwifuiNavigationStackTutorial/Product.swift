//
//  Product.swift
//  SchoolStudentApp
//
//  Created by Rajesh Mani on 31/07/25.
// reference: https://swift-pal.com
import Foundation
import SwiftData

@Model
class Product: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var descriptionn: String
    var price: Double
    init(id: UUID, name: String, descriptionn: String, price: Double) {
        self.id = id
        self.name = name
        self.descriptionn = descriptionn
        self.price = price
    }
}
