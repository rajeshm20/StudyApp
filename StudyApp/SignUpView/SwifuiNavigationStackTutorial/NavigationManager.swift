//
//  NavigationManager.swift
//  SchoolStudentApp
//
//  Created by Rajesh Mani on 31/07/25.
// reference: https://swift-pal.com

import Combine
import SwiftUI

@Observable
class NavigationManager {
    var path = NavigationPath()
    private var destinations: [AppDestination] = []

    // Current navigation state
    var currentDestination: AppDestination? {
        destinations.last
    }

    var navigationHistory: [AppDestination] {
        destinations
    }

    func navigate(to destination: AppDestination) {
        destinations.append(destination)
        path.append(destination)
    }

    func goBack() {
        guard !destinations.isEmpty else { return }
        destinations.removeLast()
        path.removeLast()
    }

    // The magic: Navigate back to a specific destination
    func goBackTo(_ targetDestination: AppDestination) {
        guard let targetIndex = destinations.lastIndex(of: targetDestination) else {
            // Target not in history, navigate fresh
            navigate(to: targetDestination)
            return
        }

        // Calculate how many screens to pop
        let itemsToRemove = destinations.count - targetIndex - 1

        // Remove from both our tracking and NavigationPath
        destinations.removeLast(itemsToRemove)
        path.removeLast(itemsToRemove)
    }

    // Helper: Check if a destination exists in current navigation stack
    func canGoBackTo(_ destination: AppDestination) -> Bool {
        destinations.contains(destination)
    }
}
