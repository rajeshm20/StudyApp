//
//  NotificationsVieww.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

// MARK: - Reusable Toggle Row

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

// MARK: - Notifications View

struct NotificationsSettingsView: View {
    @State private var emailNotifications = true
    @State private var appsUpdate = true
    @State private var recommendations = false
    @State private var messages = true
    var router: Router<MainRoute>

    var body: some View {
        VStack {
            List {
                NotificationToggleRow(
                    title: "Email Notification",
                    subtitle: "Enable / disable email notification",
                    isOn: $emailNotifications
                )
                NotificationToggleRow(
                    title: "Apps Update",
                    subtitle: "Enable auto update",
                    isOn: $appsUpdate
                )
                NotificationToggleRow(
                    title: "Recommandation",
                    subtitle: "Recommand friends to try new apps",
                    isOn: $recommendations
                )
                NotificationToggleRow(
                    title: "Messages",
                    subtitle: "Enable to receive messages",
                    isOn: $messages
                )
            }
            .foregroundStyle(.black)
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NotificationsSettingsView(router: Router<MainRoute>())
}
