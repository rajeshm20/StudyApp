//
//  ProfileViewAlternate.swift
//  StudyApp
//
//  Created by Rajesh Mani on 30/10/25.
//
import SwiftUI

struct ProfileViewAlternate: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 15) {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("JW")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        )

                    Text("Jenny Wilson")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Student ID: 2023001234")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 30)

                // Profile Stats
                HStack(spacing: 20) {
                    ProfileStatView(title: "GPA", value: "3.85", color: .green)
                    ProfileStatView(title: "Credits", value: "24", color: .blue)
                    ProfileStatView(title: "Semester", value: "Fall '25", color: .orange)
                }
                .padding(.horizontal, 20)

                // Profile Options
                VStack(spacing: 12) {
                    ProfileOptionRow(icon: "gear", title: "Settings", color: .gray)
                    ProfileOptionRow(icon: "bell", title: "Notifications", color: .orange)
                    ProfileOptionRow(icon: "questionmark.circle", title: "Help & Support", color: .blue)
                    ProfileOptionRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", color: .red)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ProfileViewAlternate()
}
