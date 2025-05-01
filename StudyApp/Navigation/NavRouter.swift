//
//  NavRouter.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/04/25.
//

import Foundation
import SwiftUI
import Observation


@Observable class Router {
    var path = NavigationPath ()

    func navigateToVerify() {
        path.append (Route.verify)
    }
    func navigateToSetup () {
        path.append (Route.setup)
    }
    func navigateToQuestionaire() {
        path.append (Route.questionaire)
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
}
enum Route: Hashable {
    case setup
    case verify
    case questionaire
}
