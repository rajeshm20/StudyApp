//
//  MainFlowView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//
import SwiftUI
import Observation

struct MainFlowView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<MainRoute>()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            StudentDashboardView(router: router)
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .dashboard:
                        StudentDashboardView(router: router)
                    case .profile:
                        ProfilePageView(router: router)
                    case .account:
                        AccountView(router: router)
                    case .settings:
                        SettingsView(router: router)
                    case .aboutus:
                        AboutUsView(router: router)
                    case .notifications:
                        NotificationsView(router: router)
                    case .countries:
                        ChooseLanguageView(router: router)
                    case .termsConditions:
                        TermsAndConditionsView(router: router)
                    case .datapolicy:
                        DataPolicyView(router: router)
                    }
                }
           }
    }
}

#Preview {
    MainFlowView()
        .environmentObject(AppCoordinator())
}

