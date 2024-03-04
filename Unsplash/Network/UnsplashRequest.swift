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
    var urlString: String { "https://api.unsplash.com" }
    var httpMethod: HTTPMethod {
        switch self {
        case .main:
            return .get
        case .random:
            return .get
        case .detail:
            return .get
        case .search:
            return .get
        }
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
    var contentType: [String : String]? {
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
}
