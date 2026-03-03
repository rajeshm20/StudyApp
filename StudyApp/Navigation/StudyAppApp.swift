//
//  StudyAppApp.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/09/24.
//

import Observation
import SwiftData
import SwiftUI

@main
struct StudyAppApp: App {
    @StateObject var popupManager: PopupManager = .init()
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
                            PopupView(
                                title: popupManager.title,
                                image: popupManager.image,
                                message: popupManager.message,
                                onClose: {
                                    // Call dynamic action if set, otherwise just dismiss
                                    if let close = popupManager.onClose {
                                        close()
                                    } else {
                                        popupManager.isVisible = false
                                    }
                                    // Always clear handler after running
                                    popupManager.onClose = nil
                                }
                            )
                        }
                        .transition(.scale)
                        .animation(.bouncy, value: popupManager.isVisible)
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
