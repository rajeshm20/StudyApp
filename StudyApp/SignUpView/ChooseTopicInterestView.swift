//
//  ChooseTopicInterestView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/10/25.
//

import SwiftUI

struct ChooseTopicInterestView: View {
    @State private var selectedTopics: Set<String> = ["Mathematics", "Economy"]
    var router: Router<AuthRoute> // <-- Take as parameter, don't create new

    let topics: [Topic] = [
        Topic(name: "Mathematics", subtitle: "Geometry, Algorithm", icon: "x.squareroot", color: Color.red.opacity(0.2)),
        Topic(name: "Economy", subtitle: "Stock, Property, News", icon: "chart.bar.fill", color: Color.yellow.opacity(0.2)),
        Topic(name: "English", subtitle: "Grammar, Literature", icon: "book.fill", color: Color.blue.opacity(0.2)),
        Topic(name: "Biology", subtitle: "Cells, Plants, Animals", icon: "leaf.fill", color: Color.green.opacity(0.2)),
        Topic(name: "Geography", subtitle: "Maps, Climate, Earth", icon: "globe.fill", color: Color.gray.opacity(0.2)),
    ]

    var body: some View {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 6) {
                Text("Choose your topic interest")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit enim, ac amet ultrices.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            // Topics list
            VStack(spacing: 16) {
                ForEach(topics) { topic in
                    TopicRow(topic: topic, isSelected: selectedTopics.contains(topic.name)) {
                        toggleSelection(for: topic.name)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()

            // Continue button
            Button(action: {
                // Continue action
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedTopics.isEmpty ? Color.blue.opacity(0.4) : Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
            }
            .disabled(selectedTopics.isEmpty)

            Spacer(minLength: 20)
        }
    }

    // MARK: - Helpers

    private func toggleSelection(for topic: String) {
        if selectedTopics.contains(topic) {
            selectedTopics.remove(topic)
        } else {
            selectedTopics.insert(topic)
        }
    }
}

struct Topic: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct TopicRow: View {
    let topic: Topic
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(topic.color)
                    .frame(width: 50, height: 50)

                Image(systemName: topic.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(topic.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(topic.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 26, height: 26)

                if isSelected {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 26, height: 26)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                        )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ChooseTopicInterestView(router: Router<AuthRoute>())
}
