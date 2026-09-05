//
//  StudyAppTests.swift
//  StudyAppTests
//
//  Created by Rajesh Mani on 21/09/24.
//

@testable import StudyApp
import Testing
import Foundation
import Security

struct StudyAppTests {
    @Test("URLSession enforces TLS 1.2 minimum protocol version")
    func urlSessionEnforcesMinimumTLS12() {
        let config = AuthSessionManager.urlSession.configuration
        #expect(config.tlsMinimumSupportedProtocolVersion == .TLSv12)
    }

    @Test("URLSession supports TLS 1.3 maximum protocol version")
    func urlSessionSupportsMaximumTLS13() {
        let config = AuthSessionManager.urlSession.configuration
        #expect(config.tlsMaximumSupportedProtocolVersion == .TLSv13)
    }

    @Test("URLSession timeout configuration is robust")
    func urlSessionTimeoutConfiguration() {
        let config = AuthSessionManager.urlSession.configuration
        #expect(config.timeoutIntervalForRequest == 30)
        #expect(config.timeoutIntervalForResource == 60)
    }
}
