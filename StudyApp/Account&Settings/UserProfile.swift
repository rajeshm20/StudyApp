//
//  UserProfile.swift
//  StudyApp
//
//  Created by Rajesh Mani on 15/10/25.
//

import Foundation

struct UserProfile: Codable {
    let name: String
    let email: String
    let dateOfBirth: String
    let phoneNumber: String
    let studentID: String
    let gender: String
    let address: String
    let profileImage: String
}
