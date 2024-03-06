//
//  NetworkError.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/06.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknownError(description: String)
    case responseError(statusCode: Int)
    case emptyDataError
    
    var description: String {
        switch self {
        case .unknownError(let description):
            return "\(description)"
        case .responseError(let statusCode):
            return "Response Error: \(statusCode)"
        case .emptyDataError:
            return "서버에 해당 데이터가 존재하지 않아 데이터를 불러오지 못했습니다."
        }
    }
}
