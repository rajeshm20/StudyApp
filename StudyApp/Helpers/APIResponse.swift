////
////  approach.swift
////  StudyApp
////
////  Created by Rajesh Mani on 31/08/25.
////
//
//import Foundation
//
//// ✅ The enum approach that eliminates impossible states
//enum APIResponse {
//    case success(Data, statusCode: Int)
//    case failure(Error, statusCode: Int)
//    case loading
//    case idle
//}
//
//// Now it's impossible to have invalid combinations
//func handleResponse(_ response: APIResponse) {
//    switch response {
//    case .success(let data, let statusCode):
//        // Guaranteed to have data, guaranteed no error
//        processSuccessfulResponse(data, statusCode: statusCode)
//    case .failure(let error, let statusCode):
//        // Guaranteed to have error, guaranteed no data
//        handleError(error, statusCode: statusCode)
//    case .loading:
//        showLoadingIndicator()
//    case .idle:
//        // Initial state
//        break
//    }
//}
//enum NetworkState {
//    case idle                           // 1 byte (just the discriminator)
//    case loading                        // 1 byte
//    case success(Data)                  // Size of Data + discriminator
//    case failure(NetworkError)          // Size of NetworkError + discriminator
//}
//
//
//enum HTTPMethod {
//    case get
//    case post(Data)
//    case put(Data)
//    case patch(Data)
//    case delete
//}
//
//enum APIEndpoint {
//    case users
//    case userDetail(userID: String)
//    case createPost(title: String, content: String)
//    case uploadImage(Data)
//    case search(query: String, filters: [String: Any])
//    
//    var path: String {
//        switch self {
//        case .users:
//            return "/users"
//        case .userDetail(let userID):
//            return "/users/\(userID)"
//        case .createPost:
//            return "/posts"
//        case .uploadImage:
//            return "/media/upload"
//        case .search:
//            return "/search"
//        }
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .users, .userDetail, .search:
//            return .get
//        case .createPost(let title, let content):
//            let postData = ["title": title, "content": content]
//            let jsonData = try! JSONSerialization.data(withJSONObject: postData)
//            return .post(jsonData)
//        case .uploadImage(let imageData):
//            return .post(imageData)
//        }
//    }
//}
//
//
//class NetworkManager {
//    func request(_ endpoint: APIEndpoint) async throws -> Data {
//        let url = baseURL.appendingPathComponent(endpoint.path)
//        let request = URLRequest(url: url)
//        let configuredRequest = endpoint.method.configure(request)
//        
//        let (data, _) = try await URLSession.shared.data(for: configuredRequest)
//        return data
//    }
//}
//
//// Usage is now impossible to get wrong:
//let users = try await networkManager.request(.users)
//let user = try await networkManager.request(.userDetail(userID: "123"))
//let searchResults = try await networkManager.request(.search(query: "Swift", filters: [:]))
