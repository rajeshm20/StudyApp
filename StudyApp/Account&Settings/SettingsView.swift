//
//  SettingsView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    @State private var showVersionMessage = false
    var router: Router<MainRoute>

    var body: some View {
        List {
            Button(action: {
                router.push(.countries)
            }) {
                HStack {
                    Text(localizationService.text(.settingsAppLanguage))
                    Spacer()
                    Text(localizationService.currentLanguage.nativeName)
                        .foregroundStyle(.secondary)
                }
            }
            Button(action: {
                router.push(.notifications)
            }) {
                Text(localizationService.text(.settingsNotifications))
            }
            Button(action: {
                showVersionMessage = true
            }) {
                Text(localizationService.text(.settingsUpdateVersion))
            }
        }
        .font(.headline)
        .foregroundStyle(.black)
        .navigationTitle(localizationService.text(.settingsTitle))
        .navigationBarTitleDisplayMode(.inline)
        .alert(localizationService.text(.settingsUpdateVersion), isPresented: $showVersionMessage) {
            Button(localizationService.text(.commonOk), role: .cancel) {}
        } message: {
            Text(localizationService.text(.commonComingSoon))
        }
    }
}

#Preview {
    SettingsView(router: Router<MainRoute>())
}
