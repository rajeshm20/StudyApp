//
//  MyCourseView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 11/11/25.
//

import SwiftUI

struct MyCourseView: View {
    var router: Router<MainRoute>
    @State private var inProgressCourses: [CourseProgress] = [
        .init(title: "How to prepare your documentation assignment", progress: 23, total: 28, image: "thumbsUp"),
        .init(title: "How to prepare your documentation assignment", progress: 16, total: 28, image: "studyFemale1"),
        .init(title: "How to prepare your documentation assignment", progress: 16, total: 28, image: "standingFemale")
    ]
    
    @State private var completedCourses: [CourseProgress] = [
        .init(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", progress: 28, total: 28, image: "standingFemale"),
        .init(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", progress: 28, total: 28, image: "student2")
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                
                // MARK: - In Progress
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Course in progress")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Button("View all") {}
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        ForEach(inProgressCourses.indices, id: \.self) { index in
                            CourseCardView(course: inProgressCourses[index],
                                           isHighlighted: index == 0)
                                .padding(.horizontal)
                        }
                    }
                }
                
                // MARK: - Completed Courses
                VStack(alignment: .leading, spacing: 16) {
                    Text("Completed course")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(completedCourses.indices, id: \.self) { index in
                            CompletedCourseView(course: completedCourses[index])
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle("My Course")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}

// MARK: - Model
struct CourseProgress {
    let title: String
    let progress: Int
    let total: Int
    let image: String
}

// MARK: - Course Card View
struct CourseCardView: View {
    let course: CourseProgress
    let isHighlighted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(course.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(course.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isHighlighted ? .white : .black)
                        .lineLimit(2)
                    
                    Text("\(course.progress)/\(course.total) Lesson")
                        .font(.caption)
                        .foregroundColor(isHighlighted ? .white.opacity(0.85) : .gray)
                }
                Spacer()
            }
            
            ProgressView(value: Float(course.progress), total: Float(course.total))
                .tint(isHighlighted ? Color.orange : Color.blue)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 4)
                .cornerRadius(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isHighlighted ? .init(hex: "132440") : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isHighlighted ? Color.blue.opacity(0.6) : Color.clear, lineWidth: 1)
                )
        )
        .shadow(color: isHighlighted ? Color.blue.opacity(0.15) : Color.clear, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Completed Course Card
struct CompletedCourseView: View {
    let course: CourseProgress
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
                .font(.title2)
            
            Text(course.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green)
        )
    }
}

#Preview {
    NavigationStack {
        MyCourseView(router: Router<MainRoute>())
    }
}
