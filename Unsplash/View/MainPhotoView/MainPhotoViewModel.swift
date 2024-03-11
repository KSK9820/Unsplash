//
//  MainPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/11.
//

import Foundation

public class MainPhotoViewModel {
    private let serviceManager = PhotoServiceManager()
    
    private var photoInformation = Binding<[MainPhotoDTO]>([])
    private var photoList = Binding<[Data]>([])
    
    func getPhotos() {
        serviceManager.getMainPhotoList { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInformation.value += data
                for info in data {
                    let url = info.urls.thumb
                    
                    self?.serviceManager.getPhoto(urlString: url) { [weak self] result in
                        switch result {
                        case .success(let data):
                            self?.photoList.value.append(data)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
