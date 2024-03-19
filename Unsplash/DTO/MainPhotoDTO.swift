//
//  MainPhotoDTO.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/06.
//
//
import Foundation

struct MainPhotoDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let altDescription: String?
    let urls: URLs
    
    enum CodingKeys: String, CodingKey {
        case altDescription = "alt_description"
        case id, width, height, description, urls
    }
}

struct URLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
