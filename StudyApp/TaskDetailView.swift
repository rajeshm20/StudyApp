//
//  TaskDetailView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/10/25.
//

import SwiftUI

struct TaskDetailView: View {
    @State private var fileName: String? = nil
    @State private var isFileUploaded = false
    var router: Router<MainRoute>

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: Header

            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color.green)
                    }
                    .padding(20)

                Text("Biology")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.top, 8)

            // MARK: Title

            Text("Doing Personal Task")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)

            // MARK: Description

            Text("""
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequat tincidunt pretium velit sem viverra. Turpis sed fames nisi, iaculis in velit volutpat morbi.
            ipsum dolor sit amet, consectetur adipiscing elit. Consequat tincidunt pretium velit sem viverra. Turpis sed fames nisi, iaculis in velit volutpat morbi.
            """)
            .multilineTextAlignment(.leading)
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .lineSpacing(3)
            .padding([.top, .bottom], 20)

            // MARK: Details Section

            VStack(alignment: .leading, spacing: 12) {
                detailRow(title: "Date Created", value: "January 12, 21; 08:00 AM")
                detailRow(title: "Deadline", value: "January 14, 21; 14:00 PM")
                detailRow(title: "Assignment Type", value: "Document")
                detailRow(title: "Status", value: "-")
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)

            // MARK: Upload Box

            VStack(spacing: 8) {
                Image(systemName: "icloud.and.arrow.up")
                    .font(.system(size: 36))
                    .foregroundColor(Color.blue.opacity(0.8))
                    .padding(.bottom, 4)

                Text(fileName ?? "Biology task.txt")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.top, 4)
            .onTapGesture {
                // Simulate upload logic
                withAnimation {
                    fileName = "Biology task.txt"
                    isFileUploaded = true
                }
            }
            Spacer()

            // MARK: Upload Button

            Button(action: {
                print("Upload triggered!")
            }) {
                Text("Upload")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background(isFileUploaded ? Color.blue : Color.gray.opacity(0.4))
                    .cornerRadius(10)
            }
            .disabled(!isFileUploaded)
            .padding(.top, 8)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: Reusable Detail Row

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.blue)
                .font(.system(size: 14, weight: .semibold))
            Spacer()
            Text(value)
                .foregroundColor(.black)
                .font(.system(size: 14))
        }
    }
}

#Preview {
    TaskDetailView(router: Router<MainRoute>())
}
