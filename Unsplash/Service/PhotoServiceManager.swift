//
//  PhotoServiceManager.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import Foundation

final class PhotoServiceManager {
    
    private let networkManager: NetworkSessionProtocol
    private let converter = JSONConverter()
    
    init(networkManager: NetworkSessionProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getPhotoList<T: Decodable>(request: URLRequest, 
                                    completion: @escaping (Result<T, Error>) -> Void) {
        networkManager.dataTask(with: request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodedData = try? self?.converter.decode(type: T.self, from: data) else {
                    return completion(.failure(ConvertError.decodeError))
                }
                
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhoto(urlString: String,
                  completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(ConvertError.urlError))
        }
        
        let request = URLRequest(url: url)
        
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: - UnsplashRequest 전용 메서드

extension PhotoServiceManager {
    
    func getMainPhotoList(completion: @escaping (Result<[MainPhotoDTO], Error>) -> Void) {
        guard let request = UnsplashRequest.main.asURLRequest() else {
            return completion(.failure(ConvertError.urlRequestError))
        }
        
        getPhotoList(request: request) { (result: Result<[MainPhotoDTO], Error>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
