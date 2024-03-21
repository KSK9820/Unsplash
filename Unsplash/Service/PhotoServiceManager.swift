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
    
    // MARK: - internal method
    // MARK: - UnsplashRequest 전용 메서드
    
    func getMainPhotoList(page: String, completion: @escaping (Result<[MainPhotoDTO], Error>) -> Void) {
        guard let request = UnsplashRequest.main(page: page).asURLRequest() else {
            return completion(.failure(ConvertError.urlRequestError))
        }
        
        getData(request: request) { (result: Result<[MainPhotoDTO], Error>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - private method
    
    private func getData<T: Decodable>(request: URLRequest,
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
    
}
