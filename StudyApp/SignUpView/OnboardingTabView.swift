import SwiftUI

struct OnboardingTabView: View {
    @State private var selectedTab = 0
    var router = Router<AuthRoute>()

    var body: some View {
        // Top navigation section
        HStack {
            Button(action: {
                // Handle back action
                if selectedTab > 0 {
                    selectedTab -= 1
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            .disabled(selectedTab == 0)

            Spacer()

            // Page indicator dots
            let pageCount = 3
            HStack(spacing: 6) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(selectedTab == index ? Color.blue : Color.gray.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
            }
            Spacer()

            Button("Skip") {
                // Handle skip action
                selectedTab = pageCount -  1
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top)
        
        TabView(selection: $selectedTab) {
            CreateProfileView()
                .tag(0)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            ChooseTopicInterestView()
                .tag(1)
                .tabItem {
                    Label("Topics", systemImage: "list.bullet")
                }
            NotificationPermissionView(router: router)
                .tag(2)
                .tabItem {
                    Label("Notifications", systemImage: "bell.badge")
                }
        }
        .tabViewStyle(.page)
//        .indexViewStyle(.page(backgroundDisplayMode: .always)) // Optional: page dots
    }
}

#Preview {
    OnboardingTabView()
}
