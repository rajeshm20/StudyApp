import SwiftUI

struct PopupView: View {
    var title: String
    var message: String
    var buttonTitle: String = "Close"
    var onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Checkmark circle
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 90, height: 90)
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.blue)
            }

            // Title
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.black)

            // Message
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 24)

            // Close button
            Button(action: onClose) {
                Text(buttonTitle)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .frame(maxWidth: 300)
    }
}