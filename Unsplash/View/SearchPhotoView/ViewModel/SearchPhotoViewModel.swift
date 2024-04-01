//
//  SearchPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/01.
//

import Foundation

final class SearchPhotoViewModel {
    
    private let serviceManager = PhotoServiceManager()
    
    
    // MARK: - internal method

    func getSearchResult(_ keyword: String) {
        serviceManager.getSearchPhotoList(keyword: keyword) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
