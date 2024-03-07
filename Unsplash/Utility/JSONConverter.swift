//
//  JSONConverter.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import Foundation

struct JSONConverter {
    static func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T? {
        
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(type, from: data)
        
        return decodedData
    }
}
