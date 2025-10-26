//
//  AssignmentCategory.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/10/25.
//
import Foundation

// MARK: - Models

struct AssignmentCategory: Identifiable, Decodable {
    let id = UUID()
    let subject: String
    let icon: String
    let color: String
    let tasks: [AssignmentItem]
    
    enum CodingKeys: String, CodingKey {
        case subject, icon, color, tasks
    }
}

struct AssignmentItem: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let dueDate: String
    let daysLeft: Int
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, dueDate, daysLeft, completed
    }
}
