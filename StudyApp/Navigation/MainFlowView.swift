//
//  MainFlowView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//
import Observation
import SwiftUI

struct MainFlowView: View {
//    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var router = Router<MainRoute>()

    var body: some View {
        NavigationStack(path: $router.path) {
            StudentDashboardView(router: router)
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .profile:
                        ProfilePageView(router: router)
                    case .account:
                        AccountView(router: router)
                    case .settings:
                        SettingsView(router: router)
                    case .about:
                        AboutView(router: router)
                    case .notifications:
                        NotificationsSettingsView(router: router)
                    case .countries:
                        ChooseLanguageView(router: router)
                    case .termsConditions:
                        TermsAndConditionsView(router: router)
                    case .datapolicy:
                        DataPolicyView(router: router)
                    case .aboutUs:
                        AboutUsView(router: router)
                    case .assignmentDetails:
                        TaskDetailView(router: router)
                    case .courses:
                        CourseView(router: router)
                    case .courseDetails:
                        CourseDetailsView(router: router)
                    case .mycourse:
                        MyCourseView(router: router)
                    case .myClasses:
                        MyClassView(router: router)
                    case .myPresence:
                        PresenceView(router: router)
                    }
                }
        }
    }
}

#Preview {
    MainFlowView()
        .environmentObject(AppCoordinator())
}
