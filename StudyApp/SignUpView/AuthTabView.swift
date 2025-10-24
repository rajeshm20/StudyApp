import SwiftUI

struct AuthTabView: View {
    var body: some View {
        TabView {
            SignUpView(router: Router<AuthRoute>())
                .tabItem {
                    Label("Sign Up", systemImage: "person.badge.plus")
                }

            SignInView(router: Router<AuthRoute>())
                .tabItem {
                    Label("Sign In", systemImage: "lock.fill")
                }

            CreateProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    AuthTabView()
        .environmentObject(AppCoordinator())
}
