import SwiftUI

struct OnboardingTabView: View {
    var body: some View {
        TabView {
            ChooseTopicInterestView()
                .tabItem {
                    Label("Topics", systemImage: "list.bullet")
                }
            CreateProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            NotificationPermissionView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.badge")
                }
        }
        .tabViewStyle(.page)
        // .indexViewStyle(.page(backgroundDisplayMode: .always)) // Optional: page dots
    }
}

#Preview {
    OnboardingTabView()
}
