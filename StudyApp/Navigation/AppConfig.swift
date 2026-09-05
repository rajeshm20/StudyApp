//
//  AppConfig.swift
//  StudyApp
//
//  Created by Rajesh Mani on 24/07/26.
//
import Foundation
import CryptoKit
import DeviceCheck


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

    static func encrypt(plaintext: Data, someData: Data) throws {
        let digest = SHA256.hash(data: someData)

            // Symmetric encryption (AES-GCM) — authenticated encryption, not just confidentiality
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try AES.GCM.seal(plaintext, using: key)
        let combined = sealedBox.combined! // nonce + ciphertext + tag, safe to store/transmit together

            // Decryption
        let box = try AES.GCM.SealedBox(combined: combined)
        let decrypted = try AES.GCM.open(box, using: key)

    }

//    func attestDevice() async throws -> Data {
//        let service = DCAppAttestService.shared
//        guard service.isSupported else { throw AttestError.unsupported }
//        let keyID = try await service.generateKey()
//        let challenge = try await fetchChallengeFromServer()
//        let attestation = try await service.attestKey(keyID, clientDataHash: SHA256.hash(data: challenge))
//        return attestation // send to server for verification against Apple's attestation root cert
//    }

}

    // Hashing
