//
//  DetailPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import Foundation

final class DetailPhotoViewModel {
    
    private let serviceManager = PhotoServiceManager()
    
    private(set) var photoInformation: DetailPhotoDTO?
    
    func getPhotoInformation(id: String) {
        serviceManager.getDetailPhoto(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInformation = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
