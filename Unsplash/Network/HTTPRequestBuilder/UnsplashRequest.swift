//
//  UnsplashRequest.swift
//  Unsplash
//
//  Created by 김수경 on 2024/02/28.
//

import Foundation

enum UnsplashRequest {
    case main(page: String)
    case random
    case detail(id: String)
    case download(id: String)
    case search(keyword: String, page: String)
}

extension UnsplashRequest: HTTPRequestable {
    private var apiKey: String {
        get throws {
            guard let apiKey = Bundle.main.infoDictionary?["UNSPLASH_KEY"] as? String
            else {
                throw NetworkError.notFoundAPIKey
            }
            return apiKey
        }
    }
    
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
        case .download(let id):
            return ["/photos", id, "download"]
        case .search:
            return ["/search", "photos"]
        }
    }
    
    var queries: [URLQueryItem]? {
        switch self {
        case .main(let nextPage):
            return [URLQueryItem(name: "per_page", value: "10"), URLQueryItem(name: "page", value: nextPage)]
        case .search(let keyword, let page):
            return [URLQueryItem(name: "query", value: keyword), URLQueryItem(name: "page", value: page)]
        default:
            return nil
        }
    }
    
    var httpHeaders: [String : String]? {
        do {
            var headers = ["Authorization" : "Client-ID \(try apiKey)"]
            switch self {
            default:
                break
            }
            return headers
        } catch {
            print(error)
        }
        
        return nil
    }
}
