//
//  DetailPhotoDTO.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import Foundation

struct DetailPhotoDTO: Decodable {
    let id: String
    let width: Int
    let height: Int
    let description: String?
    let altDescription: String?
    let urls: URLs
    let links: Link
    let tags: [Tag]
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case altDescription = "alt_description"
        case id, width, height, description, urls, links, tags, user
    }
    
}

struct Tag: Decodable {
    let title: String
}

struct User: Decodable {
    let userName: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
    }
}

struct Link: Decodable {
    let download: String
}
