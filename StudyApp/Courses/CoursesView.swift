//
//  CoursesView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/11/25.
//

import SwiftUI

struct CourseView: View {
    @State private var selectedCategory = "All"
    var router: Router<MainRoute>

    private let categories = ["All", "Mathematics", "Biology", "English"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Header Banner

                TabView {
                    VStack(spacing: 16) {
                        VStack {
                            Text("Upgrade your skill and get\nyour certified Courses")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                            AppButton(
                                title: "Go to my courses",
                                style: .outline,
                                foregroundColor: .white,
                                backgroundColor: .white,
                                cornerRadius: 8,
                                font: .system(size: 18, weight: .bold),
                                fullWidth: true,
                                isLoading: false,
                                isDisabled: false
                            ) {
                                // action here
                            }
                            .padding(.horizontal, 0)
                        }
                        .padding(5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.9), Color.cyan.opacity(0.8), Color.cyan.opacity(0.7)]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(25)
                    .padding(.horizontal)
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 180)

                // MARK: - Categories

                HStack {
                    Text("Categories")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Button("View all") {
                        // Action
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)

                // Segmented Category Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == category ?
                                            Color.blue.opacity(0.1) : Color.gray.opacity(0.1)
                                    )
                                    .foregroundColor(
                                        selectedCategory == category ? .blue : .gray
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Course List

                VStack(spacing: 16) {
                    ForEach(courseData) { course in
                        HStack(alignment: .top, spacing: 12) {
                            Image(course.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 6) {
                                Text(course.title)
                                    .font(.headline)
                                    .foregroundColor(.black)

                                Text(course.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .onTapGesture {
                                router.push(.mycourse)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.top)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("Course", displayMode: .inline)
    }
}

// MARK: - Sample Data

struct Course: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
}

let courseData = [
    Course(image: "student2", title: "How to make your design more artful & lyrical", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
    Course(image: "zenchung", title: "How to make your paper more powerful and high value", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
    Course(image: "smilyBlack", title: "How to prepare your documentation assignment", subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
]

#Preview {
    CourseView(router: Router<MainRoute>())
}
