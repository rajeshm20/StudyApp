import SwiftUI

struct OnboardingTabView: View {
    @State private var selectedTab = 0
    var router: Router<AuthRoute> // <-- Take as parameter, don't create new
    let pageCount = 3
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        // Top navigation section
        HStack {
            Button(action: {
                if selectedTab > 0 {
                    withAnimation { selectedTab -= 1 }
                } else {
                    dismiss()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            .disabled(selectedTab == 0 && !canGoBackInNavStack())
            
            Spacer()

            HStack(spacing: 6) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .fill(selectedTab == index ? Color.blue : Color.gray.opacity(0.4))
                        .frame(width: 6, height: 6)
                }
            }
            Spacer()

            Button("Skip") {
                withAnimation { selectedTab = pageCount - 1 }
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top)
        .navigationBarBackButtonHidden(true)
        
        TabView(selection: $selectedTab) {
            CreateProfileView(router: router)
                .tag(0)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
            ChooseTopicInterestView(router: router)
                .tag(1)
                .tabItem {
                    Label("Topics", systemImage: "list.bullet")
                }
            NotificationPermissionView(router: router) // <-- Pass router
                .tag(2)
                .tabItem {
                    Label("Notifications", systemImage: "bell.badge")
                }
        }
        .tabViewStyle(.page)
    }

    private func canGoBackInNavStack() -> Bool { true }
}

#Preview {
    OnboardingTabView(router: Router<AuthRoute>())
}
