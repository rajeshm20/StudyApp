//
//  SettingsView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 21/10/25.
//

import SwiftUI

struct SettingsView: View {
    var router: Router<MainRoute>
    var body: some View {
        VStack {
            List {
                Button(action: {
                    router.push(.countries)
                }) {
                    Text("App language")
                }
                Button(action: {
                    router.push(.notifications)
                }) {
                    Text("Notification")
                }
                Button(action: {}) {
                    Text("Update version")
                }
            }
            .font(.headline)
            .foregroundStyle(.black)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView(router: Router<MainRoute>())
}
