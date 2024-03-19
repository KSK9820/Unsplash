//
//  ImageDataCacheManager.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/14.
//

import UIKit

final class ImageDataCacheManager {
    
    static let shared = ImageDataCacheManager()
    
    private init() { }
    
    private let storage = NSCache<NSString, NSData>()
    
    func object(key urlString: String) -> Data? {
        let cachedKey = NSString(string: urlString)
        if let cachedImage = storage.object(forKey: cachedKey) as? Data {
            return cachedImage
        }
    
        return nil
    }
    
    func setObject(object data: Data, key urlString: String) {
        let forKey = NSString(string: urlString)
        let data = NSData(data: data)
        self.storage.setObject(data, forKey: forKey)
    }
    
}
