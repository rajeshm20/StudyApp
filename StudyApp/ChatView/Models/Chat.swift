//
//  Chat.swift
//  StudyApp
//
//  Created by Rajesh Mani on 25/11/25.
//

import Foundation

struct Chat: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let avatarURL: String?
}
