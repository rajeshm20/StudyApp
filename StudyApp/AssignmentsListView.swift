//
//  AssignmentsListView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/10/25.
//
import SwiftUI

// MARK: - List View

struct AssignmentsListView: View {
    @State private var showSheet = false
    @Binding var showListView: Bool
    @State private var categories: [AssignmentCategory] = []
    @State private var selectedItems = Set<Portfolio>()
    @State private var selectionMode: SelectionMode = .single // Default to multiple selection
    var router: Router<MainRoute>

    let data = [
        Portfolio(id: UUID(), displayTitle: "See all assignments"),
        Portfolio(id: UUID(), displayTitle: "New assignments"),
        Portfolio(id: UUID(), displayTitle: "Ongoing assignments"),
        Portfolio(id: UUID(), displayTitle: "Completed assignments"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Assignments")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                HStack(spacing: 12) {
                    Button(action: { showListView = false }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .frame(width: 32, height: 32)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Button(action: { showListView = true }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            HStack {
                Text("Today's")
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                Button(action: {
                    showSheet = true
                }) {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(categories) { category in
                        AssignmentCategoryCard(category: category)
                    }
                }
                .onTapGesture(perform: {
                    router.push(.assignmentDetails)
                })
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .onAppear(perform: loadMockData)
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .sheet(isPresented: $showSheet) {
            FilterBottomSheet()
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.hidden)
                .background(Color.black.opacity(0.2))
//                SelectableBottomSheet(
//                    title: "Choose your filter",
//                    items: data,
//                    selected: $selectedItems,
//                    onClose: {
//                        showSheet = false
//                    },
//                    selectionMode: selectionMode
//                )
//                .presentationDetents([.medium, .large])
        }
    }

    private func loadMockData() {
        let json = """
        [
          {
            "subject": "Biology",
            "icon": "leaf.fill",
            "color": "green",
            "tasks": [
              { "title": "Doing personal tasks", "dueDate": "12/08/2021", "daysLeft": 3, "completed": false }
            ]
          },
          {
            "subject": "Mathematics",
            "icon": "function",
            "color": "red",
            "tasks": [
              { "title": "Doing personal tasks", "dueDate": "12/08/2021", "daysLeft": 3, "completed": false }
            ]
          },
          {
            "subject": "Economy",
            "icon": "building.columns",
            "color": "orange",
            "tasks": [
              { "title": "Doing personal tasks...", "dueDate": "", "daysLeft": 3, "completed": true },
              { "title": "Create a journal economy", "dueDate": "", "daysLeft": 3, "completed": true },
              { "title": "Create analytical paper", "dueDate": "12/08/2021", "daysLeft": 3, "completed": false }
            ]
          }
        ]
        """
        if let data = json.data(using: .utf8) {
            if let decoded = try? JSONDecoder().decode([AssignmentCategory].self, from: data) {
                categories = decoded
            }
        }
    }
}

// MARK: - Category Card

struct AssignmentCategoryCard: View {
    let category: AssignmentCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: category.icon)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(Color(colorName: category.color))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Text(category.subject)
                    .font(.system(size: 16, weight: .semibold))
            }

            ForEach(category.tasks) { task in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.system(size: 15))
                            .lineLimit(1)
                        Text("\(task.daysLeft) Days")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    if task.completed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                            Text(task.dueDate)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 3)
    }
}

// MARK: - Color Extension

extension Color {
    init(colorName: String) {
        switch colorName.lowercased() {
        case "green": self = .green
        case "red": self = .red
        case "orange": self = .orange
        default: self = .gray
        }
    }
}

#Preview {
    AssignmentsListView(showListView: .constant(true), router: Router<MainRoute>())
}
