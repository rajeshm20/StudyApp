//
//  DecoderHelper.swift
//  StudyApp
//
//  Created by Rajesh Mani on 26/07/26.
//


import Foundation

enum DecoderHelper {

    static func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {

        do {
            return try decoder.decode(T.self, from: data)

        } catch let error as DecodingError {

            log(error)

            throw error

        } catch {

            print("Unexpected decoding error: \(error)")
            throw error
        }
    }

    private static func log(_ error: DecodingError) {

        switch error {

        case .typeMismatch(let type, let context):
            print("""
            ❌ Type Mismatch
            Expected: \(type)
            Path: \(codingPath(context))
            Description: \(context.debugDescription)
            """)

        case .valueNotFound(let type, let context):
            print("""
            ❌ Value Not Found
            Missing Type: \(type)
            Path: \(codingPath(context))
            Description: \(context.debugDescription)
            """)

        case .keyNotFound(let key, let context):
            print("""
            ❌ Key Not Found
            Missing Key: \(key.stringValue)
            Path: \(codingPath(context))
            Description: \(context.debugDescription)
            """)

        case .dataCorrupted(let context):
            print("""
            ❌ Data Corrupted
            Path: \(codingPath(context))
            Description: \(context.debugDescription)
            """)

        @unknown default:
            print(error)
        }
    }

    private static func codingPath(_ context: DecodingError.Context) -> String {

        context.codingPath
            .map(\.stringValue)
            .joined(separator: ".")
    }
}
