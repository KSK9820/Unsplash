//
//  UnsplashRequest.swift
//  Unsplash
//
//  Created by 김수경 on 2024/02/28.
//

import Foundation

enum UnsplashRequest {
    case main
    case random
    case detail(id: String)
    case search
}

extension UnsplashRequest: HTTPRequestable {
    static let apiKey = Bundle.main.infoDictionary?["UNSPLASH_KEY"] as! String
    
    var urlString: String { "https://api.unsplash.com" }
    var httpMethod: HTTPMethod {
        var method = HTTPMethod.get
        switch self {
        default:
            break
        }
        return method
    }
    
    var path: [String] {
        switch self {
        case .main:
            return ["/photos"]
        case .random:
            return ["/photos", "random"]
        case .detail(let id):
            return ["/photos", id]
        case .search:
            return ["/search", "photos"]
        }
    }
    
    var queries: [URLQueryItem]? {
        switch self {
        case .main:
            return nil
        case .random:
            return nil
        case .detail:
            return nil
        case .search:
            return nil
        }
    }
    
    var httpHeaders: [String : String]? {
        var headers = ["Authorization" : "Client-ID \(Self.apiKey)"]
        switch self {
        default:
            break
        }
        return headers
    }
}
