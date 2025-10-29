//
//  StudyAppApp.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/09/24.
//

import SwiftUI
import SwiftData
import Observation

@main
struct StudyAppApp: App {
    @StateObject var popupManager: PopupManager = PopupManager()
    @StateObject private var coordinator = AppCoordinator()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(coordinator)
                .environmentObject(popupManager)
                .overlay(alignment: .center) {
                    if popupManager.isVisible {
                        ZStack {
                            PopupView(title: popupManager.title, image: popupManager.image, message: popupManager.message, onClose: {
                                popupManager.isVisible = false
                            })
                        }
                        .transition(.scale)
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
