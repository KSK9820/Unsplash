//
//  ReuseIdentifiable.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/12.
//

import Foundation

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
