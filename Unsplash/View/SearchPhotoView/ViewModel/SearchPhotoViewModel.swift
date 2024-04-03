//
//  SearchPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/01.
//

import Foundation

final class SearchPhotoViewModel {
    
    private let serviceManager = PhotoServiceManager()
    
    private(set) var searchResult = Binding<SearchPhotoDTO?>(nil)
    
    // MARK: - internal method

    func getSearchResult(_ keyword: String, page: String) {
        serviceManager.getSearchPhotoList(keyword: keyword, page: page) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchResult.value = data
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImageSize(row: Int, viewWidth: CGFloat) -> CGFloat {
        guard let image = searchResult.value?.results[row] else { return CGFloat(viewWidth / 2) }
        
        let width = image.width
        let height = image.height
        
        return CGFloat(height * Int(viewWidth / 2) / width)
    }
}
