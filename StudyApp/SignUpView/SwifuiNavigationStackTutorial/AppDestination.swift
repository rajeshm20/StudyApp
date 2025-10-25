//
//  AppDestination.swift
//  SchoolStudentApp
//
//  Created by Rajesh Mani on 31/07/25.
//// reference: https://swift-pal.com


import Foundation
import SwiftUI

enum AppDestination: Hashable {
    case dashboard
    case profile(userID: String)
    case settings
    case cart
    case productDetail([Product])
    case orderHistory(userID: String, page: Int = 1)
    case account
    case about
    case help
}

