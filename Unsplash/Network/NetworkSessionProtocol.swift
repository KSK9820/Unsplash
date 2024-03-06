//
//  NetworkSessionProtocol.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/04.
//

import Foundation

protocol NetworkSessionProtocol {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Result<Data, Error>) -> Void)
}
