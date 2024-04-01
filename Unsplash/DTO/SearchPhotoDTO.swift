//
//  SearchPhotoDTO.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/01.
//

struct SearchPhotoDTO: Decodable {
    let total: Int
    let totalPages: Int
    let results: [MainPhotoDTO]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case total, results
    }
}
