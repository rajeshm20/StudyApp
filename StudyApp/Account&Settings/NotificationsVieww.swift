//
//  NotificationsVieww.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct NotificationToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 6)
    }
}

struct NotificationsSettingsView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    @State private var emailNotifications = true
    @State private var appsUpdate = true
    @State private var recommendations = false
    @State private var messages = true
    var router: Router<MainRoute>

    var body: some View {
        VStack {
            List {
                NotificationToggleRow(
                    title: localizationService.text(.notificationEmail),
                    subtitle: localizationService.text(.notificationEmailSubtitle),
                    isOn: $emailNotifications
                )
                NotificationToggleRow(
                    title: localizationService.text(.notificationUpdates),
                    subtitle: localizationService.text(.notificationUpdatesSubtitle),
                    isOn: $appsUpdate
                )
                NotificationToggleRow(
                    title: localizationService.text(.notificationRecommendations),
                    subtitle: localizationService.text(.notificationRecommendationsSubtitle),
                    isOn: $recommendations
                )
                NotificationToggleRow(
                    title: localizationService.text(.notificationMessages),
                    subtitle: localizationService.text(.notificationMessagesSubtitle),
                    isOn: $messages
                )
            }
            .foregroundStyle(.black)
        }
        .navigationTitle(localizationService.text(.notificationTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotificationsSettingsView(router: Router<MainRoute>())
}
