//
//  EncryptionManager.swift
//  StudyApp
//
//  Created by Rajesh Mani on 29/11/25.
//

import CommonCrypto // PBKDF2
import CryptoKit
import Foundation
import Security
import UIKit

/// Simple, reusable manager for encryption (AES-GCM), PBKDF2 key derivation and Keychain storage.
enum EncryptionManager {
    enum Error: Swift.Error {
        case keyDerivationFailed
        case keyConversionFailed
        case keychainSaveFailed(status: OSStatus)
        case keychainLoadFailed(status: OSStatus)
        case encryptionFailed
        case decryptionFailed
        case invalidBase64
        case invalidUTF8
    }

    // MARK: - PBKDF2 (derive key from password)

    /// Derives a symmetric key from a password using PBKDF2(SHA256).
    /// - Parameters:
    ///   - password: user password
    ///   - salt: salt bytes (recommended 16 bytes). If nil, a random salt is generated.
    ///   - iterations: iteration count (e.g. 100_000)
    ///   - keyByteCount: length of derived key in bytes (32 for AES-256)
    /// - Returns: (SymmetricKey, salt)
    static func deriveKey(
        password: String,
        salt: Data? = nil,
        iterations: UInt32 = 100_000,
        keyByteCount: Int = 32
    ) throws -> (key: SymmetricKey, salt: Data) {
        let saltData: Data = if let s = salt {
            s
        } else {
            randomData(length: 16)
        }

        var derived = [UInt8](repeating: 0, count: keyByteCount)
        let passwordData = Array(password.utf8)

        let res = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            password, passwordData.count,
            [UInt8](saltData), saltData.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            UInt32(iterations),
            &derived,
            derived.count
        )

        guard res == kCCSuccess else {
            throw Error.keyDerivationFailed
        }

        let keyData = Data(derived)
        let symKey = SymmetricKey(data: keyData)
        return (symKey, saltData)
    }

    // MARK: - AES-GCM encrypt / decrypt (CryptoKit)

    /// Encrypt plaintext using AES-GCM and return Base64(combined) string
    static func encryptAESGCM(plaintext: String, using key: SymmetricKey) throws -> String {
        let data = Data(plaintext.utf8)
        let sealed = try AES.GCM.seal(data, using: key)
        guard let combined = sealed.combined else {
            throw Error.encryptionFailed
        }
        return combined.base64EncodedString()
    }

    /// Decrypt a Base64(combined) AES-GCM sealed box to plaintext
    static func decryptAESGCM(base64Combined: String, using key: SymmetricKey) throws -> String {
        guard let combinedData = Data(base64Encoded: base64Combined) else {
            throw Error.invalidBase64
        }
        let sealedBox = try AES.GCM.SealedBox(combined: combinedData)
        let plain = try AES.GCM.open(sealedBox, using: key)
        guard let result = String(data: plain, encoding: .utf8) else {
            throw Error.invalidUTF8
        }
        return result
    }

    // MARK: - Key generation helpers

    /// Random bytes
    static func randomData(length: Int) -> Data {
        var d = Data(count: length)
        let result = d.withUnsafeMutableBytes { bytes -> Int32 in
            guard let base = bytes.baseAddress else { return -1 }
            return SecRandomCopyBytes(kSecRandomDefault, length, base)
        }
        precondition(result == errSecSuccess, "SecRandomCopyBytes failed")
        return d
    }

    /// Generate a random SymmetricKey (AES-256)
    static func generateSymmetricKey() -> SymmetricKey {
        SymmetricKey(size: .bits256)
    }

    // MARK: - Keychain storage (save & load raw key bytes)

    /// Save symmetric key raw bytes into Keychain under `account` and `service`.
    /// If an item exists, it will be updated.
    static func saveKeyToKeychain(key: SymmetricKey, account: String, service: String) throws {
        // extract raw bytes
        let keyData = key.withUnsafeBytes { Data($0) }

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ]

        // Check if exists
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            // update
            let attributesToUpdate: [CFString: Any] = [
                kSecValueData: keyData,
            ]
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw Error.keychainSaveFailed(status: status)
            }
        } else if status == errSecItemNotFound {
            // add
            var addQuery = query
            addQuery[kSecValueData] = keyData
            addQuery[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            status = SecItemAdd(addQuery as CFDictionary, nil)
            if status != errSecSuccess {
                throw Error.keychainSaveFailed(status: status)
            }
        } else {
            throw Error.keychainSaveFailed(status: status)
        }
    }

    /// Load symmetric key from Keychain
    static func loadKeyFromKeychain(account: String, service: String) throws -> SymmetricKey {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            throw Error.keychainLoadFailed(status: status)
        }
        guard let data = result as? Data else {
            throw Error.keyConversionFailed
        }
        return SymmetricKey(data: data)
    }

    /// Delete key from Keychain (optional utility)
    static func deleteKeyFromKeychain(account: String, service: String) throws {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Error.keychainLoadFailed(status: status)
        }
    }
}
