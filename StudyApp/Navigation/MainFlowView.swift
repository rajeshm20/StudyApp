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
                .screenLog("StudentDashboardView")
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case .profile:
                        ProfilePageView(router: router)
                            .screenLog("ProfilePageView")
                    case .account:
                        AccountView(router: router)
                            .screenLog("AccountView")
                    case .settings:
                        SettingsView(router: router)
                            .screenLog("SettingsView")
                    case .about:
                        AboutView(router: router)
                            .screenLog("AboutView")
                    case .notifications:
                        NotificationsSettingsView(router: router)
                            .screenLog("NotificationsSettingsView")
                    case .countries:
                        ChooseLanguageView(router: router)
                            .screenLog("ChooseLanguageView")
                    case .termsConditions:
                        TermsAndConditionsView(router: router)
                            .screenLog("TermsAndConditionsView")
                    case .datapolicy:
                        DataPolicyView(router: router)
                            .screenLog("DataPolicyView")
                    case .aboutUs:
                        AboutUsView(router: router)
                            .screenLog("AboutUsView")
                    case .assignmentDetails:
                        TaskDetailView(router: router)
                            .screenLog("TaskDetailView")
                    case .courses:
                        CourseView(router: router)
                            .screenLog("CourseView")
                    case .courseDetails:
                        CourseDetailsView(router: router)
                            .screenLog("CourseDetailsView")
                    case .mycourse:
                        MyCourseView(router: router)
                            .screenLog("MyCourseView")
                    case .myClasses:
                        MyClassView(router: router)
                            .screenLog("MyClassView")
                    case .myPresence:
                        PresenceView(router: router)
                            .screenLog("PresenceView")
                    }
                }
        }
    }
}

#Preview {
    MainFlowView()
        .environmentObject(AppCoordinator())
}
