//
//  AppDestination.swift
//  SchoolStudentApp
//
//  Created by Rajesh Mani on 31/07/25.
//

import Foundation
import SwiftUI

enum AppDestination: Hashable {
    case profile(userID: String)
    case settings
    case cart
    case productDetail([Product])
    case orderHistory(userID: String, page: Int = 1)
}

