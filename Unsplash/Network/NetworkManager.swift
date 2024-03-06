//
//  NetworkManager.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/04.
//

import Foundation

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}


// MARK: - protocol method

extension NetworkManager: NetworkSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(NetworkError.unknownError(description: error.localizedDescription)))
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(NetworkError.responseError(statusCode: httpResponse.statusCode)))
            }
            guard let data = data else {
                return completion(.failure(NetworkError.emptyDataError))
            }
            completion(.success(data))
        }
        task.resume()
    }
}
