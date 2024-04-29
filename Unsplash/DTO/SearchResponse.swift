//
//  SearchPhotoDTO.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/01.
//

struct SearchResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [SearchResultDTO]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case total, results
    }
}

struct SearchResultDTO: Decodable, Hashable, Identifiable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let altDescription: String?
    let urls: ImageURLs
    
    enum CodingKeys: String, CodingKey {
        case altDescription = "alt_description"
        case id, width, height, description, urls
    }
}

