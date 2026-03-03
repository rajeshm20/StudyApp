//
//  StateManager.swift
//  StudyApp
//
//  Created by Rajesh Mani on 31/08/25.
//

import Foundation

//
// enum FormState {
//    case editing(currentData: FormData, validation: ValidationState)
//    case submitting(data: FormData, progress: Double)
//    case submitted(result: SubmissionResult)
//    case error(FormError, retryData: FormData)
// }
//
// enum ValidationState {
//    case valid
//    case invalid(errors: [ValidationError])
//    case validating(field: String)
// }
//
// enum SubmissionResult {
//    case success(serverResponse: SuccessResponse)
//    case partialSuccess(completed: [String], failed: [String])
// }
//
// struct FormData {
//    let name: String
//    let email: String
//    let message: String
// }
//
//
// enum Weather {
//    case sunny(temperature: Int)
//    case rainy(intensity: Double, temperature: Int)
//    case snowy(accumulation: Double, temperature: Int)
//    case cloudy(coverage: Double, temperature: Int)
// }
//
// func recommendClothing(for weather: Weather) -> String {
//    switch weather {
//    case .sunny(let temp) where temp > 75:
//        return "Shorts and t-shirt"
//    case .sunny(let temp) where temp > 60:
//        return "Light jacket"
//    case .sunny:
//        return "Warm clothes, but no rain gear"
//
//
//    case .rainy(let intensity, let temp) where intensity > 0.5 && temp < 50:
//        return "Heavy rain jacket and warm clothes"
//    case .rainy(let intensity, _) where intensity > 0.5:
//        return "Umbrella or rain jacket"
//    case .rainy:
//        return "Light rain protection"
//
//
//    case .snowy(let accumulation, _) where accumulation > 2.0:
//        return "Snow boots and heavy winter gear"
//    case .snowy:
//        return "Light winter jacket"
//
//
//    case .cloudy(_, let temp) where temp < 60:
//        return "Light jacket, might get chilly"
//    case .cloudy:
//        return "Regular clothes"
//    }
// }
