import SwiftUI

struct NotificationPermissionView: View {
    var router: Router<AuthRoute>

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Text("Give me notifications")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit enim, ac amet ultrices.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)

            VStack(spacing: 12) {
                NotificationIllustration()
                    .padding(.bottom, 10)
            }

            Spacer()

            VStack(spacing: 16) {
                Button(action: {
                    router.push(.signIn)
                }) {
                    Text("Turn On Notifications")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 32)
                }

                Button(action: {
                    router.push(.signIn)
                }) {
                    Text("Remind me later")
                        .font(.headline)
                        .foregroundColor(Color.blue)
                }
            }

            Spacer(minLength: 20)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Placeholder Illustration

struct NotificationIllustration: View {
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0 ..< 3) { index in
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: CGFloat(32 - (index * 15)), height: 32)
                        .overlay(
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color.blue)
                                .font(.system(size: 14))
                        )

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.15))
                        .frame(height: 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue.opacity(0.2))
                        )

                    Spacer()
                }
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    NotificationPermissionView(router: Router<AuthRoute>())
}

// ... rest of the file unchanged ...
