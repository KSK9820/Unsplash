//
//  ImageConverter.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/18.
//

import Foundation

final class ImageConverter {
    
    private let networkManager = NetworkManager()
    
    func getImage(urlString: String,
                  completion: @escaping (Result<Data, Error>) -> Void) {
        if let cachedData = ImageDataCacheManager.shared.object(key: urlString) {
            return completion(.success(Data(cachedData)))
        }
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(ConvertError.urlError))
        }
        
        let request = URLRequest(url: url)
        
        networkManager.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                ImageDataCacheManager.shared.setObject(object: data, key: urlString)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
