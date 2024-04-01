//
//  DetailPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import Foundation

final class DetailPhotoViewModel {
    
    private let serviceManager = PhotoServiceManager()

    private(set) var topStackDataViewModel = Binding<DetailTopStackDataViewModel?>(nil)
    private(set) var imageViewDataViewModel = Binding<DetailImageDataViewModel?>(nil)
    private(set) var bottomStackDataViewModel = Binding<DetailBottomStackDataViewModel?>(nil)
    private(set) var downloadURL = Binding<String?>(nil)
    
    private(set) var photoInformation: DetailPhotoDTO?
    
    
    // MARK: - internal method
    
    func getPhotoInformation(id: String) {
        serviceManager.getDetailPhoto(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInformation = data
                
                self?.topStackDataViewModel.value = DetailTopStackDataViewModel(
                    userName: data.user.userName,
                    downloadLink: data.links.download)
                self?.imageViewDataViewModel.value = DetailImageDataViewModel(imageURL: data.urls.regular, aspectRatioOfHeight: CGFloat(data.height) / CGFloat(data.width))
                self?.bottomStackDataViewModel.value = DetailBottomStackDataViewModel(
                    title: data.altDescription,
                    description: data.description,
                    tag: data.tags
                )
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadPhoto(id: String) {
        serviceManager.downloadPhoto(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.downloadURL.value = data.url
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
