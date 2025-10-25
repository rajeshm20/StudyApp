//
//  NetworkResponseClass.swift
//  StudyApp
//
//  Created by Rajesh Mani on 31/08/25.
//

import Foundation

// Class-based approach
class NetworkResponseClass {
    let isSuccess: Bool
    let data: Data?
    let error: Error?
    let statusCode: Int?
    
    init(isSuccess: Bool, data: Data?, error: Error?, statusCode: Int?) {
        self.isSuccess = isSuccess
        self.data = data
        self.error = error
        self.statusCode = statusCode
    }
}

// Enum-based approach
enum NetworkResponseEnum {
    case success(Data, statusCode: Int)
    case failure(Error, statusCode: Int)
}

// Memory usage comparison:
//let classInstance = NetworkResponseClass(isSuccess: true, data: Data(), error: nil, statusCode: 200)
//let enumInstance = NetworkResponseEnum.success(Data(), statusCode: 200)

// Class memory: 8 bytes (object header) + 1 byte (Bool) + 8 bytes (Data?) + 8 bytes (Error?) + 8 bytes (Int?) + padding = ~40 bytes
// Enum memory: 1 byte (case discriminator) + size of largest case = much smaller

// Plus, the enum prevents invalid states while using less memory!
