//
//  HTTPRequestable.swift
//  Unsplash
//
//  Created by 김수경 on 2024/02/28.
//

import Foundation

protocol HTTPRequestable {
    var urlString: String { get }
    var httpMethod: HTTPMethod { get }
    var path: [String]? { get }
    var queries: [URLQueryItem]? { get }
    var contentType: [String: String]? { get }
    
    func asURLRequest() -> URLRequest?
}

extension HTTPRequestable {
    func asURLRequest() -> URLRequest? {
        guard var url = URL(string: urlString) else { return nil }
        if let path = path {
            url.append(path: path.joined(separator: "/"))
        }
        if let queries = queries {
            url.append(queryItems: queries)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = contentType
        
        return urlRequest
    }
}
