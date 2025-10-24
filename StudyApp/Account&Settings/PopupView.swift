//
//  PopupView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 19/10/25.
//


import SwiftUI

struct PopupView: View {
    var title: String
    var image: String
    var message: String
    var buttonTitle: String = "Close"
    var onClose: () -> Void

    var body: some View {
        ZStack() {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)

            VStack(spacing: 16) {
                // Checkmark circle
                ZStack {
                    Circle()
                        .fill(.clear)
                    Image(image)
                        .resizable()
                        .frame(width: 160, height: 120)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color.blue)
                        .scaledToFill()
                }
                .padding(0)
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
                BorderedButton(action: onClose) {
                    HStack {
                        Text(buttonTitle)
                            .foregroundStyle(Color.brandPrimary)
                    }
                }
            }
            .frame(maxWidth: 300, maxHeight: 380)
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        }
    }
}


#Preview {
    PopupView(title: "Update Success", image: "key", message: "Profile Updated\nSuccessfully!", buttonTitle: "Close", onClose: {})
}
