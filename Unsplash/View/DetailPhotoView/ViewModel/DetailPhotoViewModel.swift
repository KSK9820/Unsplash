//
//  DetailPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import Foundation

final class DetailPhotoViewModel {
    
    private let serviceManager = PhotoServiceManager()

    private(set) var topStackViewDTO = Binding<DetailTopStackViewDTO>(DetailTopStackViewDTO())
    private(set) var height = Binding<CGFloat>(CGFloat())
    private(set) var bottomStackViewDTO = Binding<DetailBottomStackViewDTO>(DetailBottomStackViewDTO())
    private(set) var downloadURL = Binding<String>(String())
    
    private(set) var photoInformation: DetailPhotoDTO?
    private(set) var imageURL: String?
    
    
    // MARK: - internal method
    
    func getPhotoInformation(id: String) {
        serviceManager.getDetailPhoto(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInformation = data
                self?.topStackViewDTO.value = DetailTopStackViewDTO(
                    userName: data.user.userName,
                    downloadLink: data.links.download)
                self?.imageURL = data.urls.full
                self?.height.value = CGFloat(data.height) / CGFloat(data.width)
                self?.bottomStackViewDTO.value = DetailBottomStackViewDTO(
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
