//
//  approach.swift
//  StudyApp
//
//  Created by Rajesh Mani on 31/08/25.
//


/ ✅ The enum approach that eliminates impossible states
enum APIResponse {
    case success(Data, statusCode: Int)
    case failure(Error, statusCode: Int)
    case loading
    case idle
}

// Now it's impossible to have invalid combinations
func handleResponse(_ response: APIResponse) {
    switch response {
    case .success(let data, let statusCode):
        // Guaranteed to have data, guaranteed no error
        processSuccessfulResponse(data, statusCode: statusCode)
    case .failure(let error, let statusCode):
        // Guaranteed to have error, guaranteed no data
        handleError(error, statusCode: statusCode)
    case .loading:
        showLoadingIndicator()
    case .idle:
        // Initial state
        break
    }
}