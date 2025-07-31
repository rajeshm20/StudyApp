//
//  NavigationManager.swift
//  SchoolStudentApp
//
//  Created by Rajesh Mani on 31/07/25.
//

import SwiftUI
import Combine

@Observable
class NavigationManager {
    var path = NavigationPath()
    private var destinations: [AppDestination] = []
    
    func navigate(to destination: AppDestination) {
        destinations.append(destination)
        path.append(destination)
    }
    
    func goBack() {
        guard !destinations.isEmpty else { return }
        destinations.removeLast()
        path.removeLast()
    }
    
    func clearNavigation() {
        destinations.removeAll()
        path = NavigationPath()
    }
}
