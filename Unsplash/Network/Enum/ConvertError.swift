//
//  ConvertError.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/11.
//

import Foundation

enum ConvertError: Error, CustomStringConvertible {
    case urlError
    case urlRequestError
    case decodeError
    
    var description: String {
        switch self {
        case .urlError:
            return "URL Convert Error"
        case .urlRequestError:
            return "URLRequest Convert Error"
        case .decodeError:
            return "Decode Error"
        }
    }
}
