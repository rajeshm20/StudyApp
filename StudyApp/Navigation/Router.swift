//
//  Router.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//

import SwiftUI
import Observation

@MainActor
final class Router<Route: Hashable>: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

// MARK: - Routes
enum AuthRoute: Hashable {
    case onboard
    case signUp
    case otp
    case userOnboard
    case signIn
}
enum MainRoute: Hashable {
    case dashboard
    case profile
    case account
    case settings
    case about
    case notifications
    case countries
    case termsConditions
    case aboutUs
    case datapolicy
}
//enum SettingsRoute: Hashable {
//}
