//
//  ViewState.swift
//  StudyApp
//
//  Created by Rajesh Mani on 31/08/25.
//
import Foundation
import UIKit

// ✅ Use enums for state machines
enum ViewState {
    case loading
    case loaded([Item])
    case error(Error)
    case empty
}

// ✅ Use enums for mutually exclusive data
enum MediaContent {
    case image(UIImage)
    case video(URL)
    case audio(URL, duration: TimeInterval)
}

// ✅ Use enums for configuration options
enum CachePolicy {
    case never
    case memory(maxSize: Int)
    case disk(maxAge: TimeInterval)
    case hybrid(memorySize: Int, diskAge: TimeInterval)
}

// ❌ Don't use enums when you need inheritance
// ❌ Don't use enums when all cases need the same stored properties
// ❌ Don't use enums when you need reference semantics

import Foundation

// Test data structures
struct ResultStruct {
    let isSuccess: Bool
    let data: Data?
    let error: Error?
}

enum ResultEnum {
    case success(Data)
    case failure(Error)
}

// Performance test
func performanceTest() {
    let iterations = 100_000
    let testData = Data(repeating: 0, count: 1000)
    let testError = NSError(domain: "test", code: 1, userInfo: nil)
    
    // Test struct creation
    let structStart = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        let _ = ResultStruct(isSuccess: true, data: testData, error: nil)
    }
    let structTime = CFAbsoluteTimeGetCurrent() - structStart
    
    // Test enum creation
    let enumStart = CFAbsoluteTimeGetCurrent()
    for _ in 0..<iterations {
        let _ = ResultEnum.success(testData)
    }
    let enumTime = CFAbsoluteTimeGetCurrent() - enumStart
    
    print("Struct time: \(structTime)s")
    print("Enum time: \(enumTime)s")
    print("Enum is \(structTime/enumTime)x faster")
}
