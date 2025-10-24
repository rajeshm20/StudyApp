import SwiftUI

struct NotificationPermissionView: View {
    var body: some View {
        VStack {
            // Top bar
            HStack {
                Button(action: {
                    // Handle back action
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }

                Spacer()

                // Progress dots
                HStack(spacing: 6) {
                    Circle().fill(Color.gray.opacity(0.4)).frame(width: 6, height: 6)
                    Circle().fill(Color.gray.opacity(0.4)).frame(width: 6, height: 6)
                    Circle().fill(Color.blue).frame(width: 6, height: 6)
                }

                Spacer()
                // Empty placeholder for alignment
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer()

            // Title and subtitle
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

            // Illustration (replace with your asset if available)
            VStack(spacing: 12) {
                NotificationIllustration()
                    .padding(.bottom, 10)
            }

            Spacer()

            // Buttons
            VStack(spacing: 16) {
                Button(action: {
                    // Request notification permissions
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
                    // Remind me later action
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
            ForEach(0..<3) { index in
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 32, height: 32)
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
    NotificationPermissionView()
}