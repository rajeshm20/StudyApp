//
//  AppConfig.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/07/26.
//
import Foundation

enum AppConfig {
    static let apiBaseURL: String = {
        guard let host = Bundle.main.infoDictionary?["API_HOST"] as? String else {
            fatalError("API_HOST not set in Info.plist")
        }
        guard let scheme = Bundle.main.infoDictionary?["API_SCHEME"] as? String else {
            fatalError("API_SCHEME not set in Info.plist")
        }

        return scheme + "://" + host
    }()

    static let enableLogging: Bool = {
        Bundle.main.infoDictionary?["ENABLE_LOGGING"] as? String == "YES"
    }()
}
