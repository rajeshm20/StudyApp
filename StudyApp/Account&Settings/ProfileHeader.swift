//
//  ProfileHeader.swift
//  StudyApp
//
//  Created by Rajesh Mani on 15/10/25.
//
import SwiftUI

struct ProfileHeader: View {
    var imageName: String

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.accent, lineWidth: 2))

            Button(action: {}) {
                Circle()
                    .fill(Color.primary)
                    .frame(width: 32, height: 32)
                    .overlay(Image(systemName: "camera.fill").foregroundColor(.white))
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    ProfileHeader(imageName: "thumbsUp")
}
