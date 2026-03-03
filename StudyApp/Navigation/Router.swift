//
//  Router.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//

import Observation
import SwiftUI

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
    func popToSignIn() {
        path.count > 1 ? path.removeLast(path.count - 2) : ()
    }
}

// MARK: - Routes

enum AuthRoute: Hashable {
    case onboard
    case signUp
    case otp
    case userOnboard
    case signIn
    case forgotPassword
    case resetPassword
}

enum MainRoute: Hashable {
    case profile
    case account
    case settings
    case about
    case assignmentDetails
    case notifications
    case countries
    case termsConditions
    case aboutUs
    case datapolicy
    case courses
    case courseDetails
    case mycourse
    case myClasses
    case myPresence
}
