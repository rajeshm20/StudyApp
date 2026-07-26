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
    @StateObject private var authSession = AuthSessionManager()
    private let logger: Logging = StudyAppLogger.shared
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showSessionExpiredAlert = false
    @State private var sessionExpiredMessage = ""

//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
                .environmentObject(coordinator)
                .environmentObject(authSession)
                .environmentObject(popupManager)
                .environment(\.logger, logger)
                .onAppear {
                    logger.notice("StudyApp launched", category: .lifecycle)
                    coordinator.currentFlow = authSession.isAuthenticated ? .main : .auth
                }
                .onChange(of: authSession.isAuthenticated) { _, isAuthenticated in
                    if !isAuthenticated {
                        coordinator.switchToAuth()
                    }
                }
                .onChange(of: authSession.forcedLogoutMessage) { _, message in
                    guard let message else { return }
                    popupManager.dismiss()
                    sessionExpiredMessage = message
                    showSessionExpiredAlert = true
                }
                .overlay(alignment: .center) {
                    if popupManager.isVisible {
                        ZStack {
                            PopupView(
                                title: popupManager.title,
                                image: popupManager.image,
                                message: popupManager.message,
                                primaryButtonTitle: popupManager.primaryButtonTitle,
                                secondaryButtonTitle: popupManager.secondaryButtonTitle,
                                onPrimary: {
                                    if let action = popupManager.onPrimary {
                                        action()
                                    } else {
                                        popupManager.dismiss()
                                    }
                                },
                                onSecondary: {
                                    if let action = popupManager.onSecondary {
                                        action()
                                    } else {
                                        popupManager.dismiss()
                                    }
                                }
                            )
                        }
                        .transition(.scale)
                        .animation(.bouncy, value: popupManager.isVisible)
                    }
                }
                .alert("Session Expired", isPresented: $showSessionExpiredAlert) {
                    Button("OK") {
                        _ = authSession.consumeForcedLogoutMessage()
                    }
                } message: {
                    Text(sessionExpiredMessage)
                }
        }
//        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                logger.info("App became active", category: .lifecycle)
            case .inactive:
                logger.info("App became inactive", category: .lifecycle)
            case .background:
                logger.info("App moved to background", category: .lifecycle)
            @unknown default:
                break
            }
        }
    }
}


struct Item {
    var text: String
}
