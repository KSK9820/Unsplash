//
//  PhotoService.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import Foundation

final class PhotoService {
    private let networkManager: NetworkSessionProtocol
    private let converter = JSONConverter()
    
    init(networkManager: NetworkSessionProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPhoto<T: Decodable>(request: URLRequest, completion: @escaping (Result<[T], Error>) -> Void) {
        networkManager.dataTask(with: request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodedData = try? self?.converter.decode(type: [T].self, from: data) else {
                    return completion(.failure(NetworkError.decodeError))
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


