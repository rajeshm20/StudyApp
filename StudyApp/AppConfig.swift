//
//  AppConfig.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/07/26.
//
import Foundation

enum AppConfig {
    static let apiBaseURL: String = {
        guard let value = Bundle.main.infoDictionary?["API_BASE_URL"] as? String else {
            fatalError("API_BASE_URL not set in Info.plist")
        }
        return value
    }()

    static let enableLogging: Bool = {
        Bundle.main.infoDictionary?["ENABLE_LOGGING"] as? String == "YES"
    }()
}
