//
//  JSONConverter.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import Foundation

struct JSONConverter {
    private let decoder = JSONDecoder()
    
    func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T? {
        
        let decodedData = try decoder.decode(T.self, from: data)

        return decodedData
    }
}
