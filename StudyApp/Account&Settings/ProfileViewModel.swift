//
//  ProfileViewModel.swift
//  StudyApp
//
//  Created by Rajesh Mani on 15/10/25.
//

import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?

    func loadMockProfile() {
        guard let url = Bundle.main.url(forResource: "profile_mock", withExtension: "json") else {
            print("❌ Mock JSON not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(UserProfile.self, from: data)
            profile = decoded
        } catch {
            print("❌ Failed to decode profile_mock.json:", error)
        }
    }
}
