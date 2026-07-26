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
    private let logger: Logging

    init(logger: Logging = StudyAppLogger.shared) {
        self.logger = logger
    }

    func push(_ route: Route) {
        logger.info("Navigation push", category: .navigation, metadata: ["route": String(describing: route)])
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        logger.info("Navigation pop", category: .navigation, metadata: ["stackDepth": String(path.count)])
        path.removeLast()
    }

    func popToRoot() {
        logger.info("Navigation pop to root", category: .navigation, metadata: ["stackDepth": String(path.count)])
        path.removeLast(path.count)
    }
    func popToSignIn() {
        logger.info("Navigation pop to sign in", category: .navigation, metadata: ["stackDepth": String(path.count)])
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
    case verifyOTP

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
