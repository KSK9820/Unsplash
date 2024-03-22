//
//  MainPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/11.
//

import Foundation

final class MainPhotoViewModel: PhotoViewModelProtocol {
    
    private let serviceManager = PhotoServiceManager()
    
    private(set) var photoInformation = Binding<[MainPhotoDTO]>([])
    private(set) var currentPage = Binding<Int>(1)
    private(set) var totalPage = Binding<Int>(1)
    
    func getPhotoInformation() {
        serviceManager.getMainPhotoList(page: String(totalPage.value)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInformation.value += data
                self?.totalPage.value += 1
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPhotoCount() -> Int {
        photoInformation.value.count
    }
    
    func getThumbURLString(index: Int) -> String {
        photoInformation.value[index].urls.thumb
    }
    
    func getImageSize(row: Int, viewWidth: CGFloat) -> CGFloat {
        let image = photoInformation.value[row]
        let width = image.width
        let height = image.height
        
        return CGFloat(height * Int(viewWidth / 2) / width)
    }
    
    func fetchNextPage() {
        currentPage.value += 1
    }
    
    func getPhotoID(index: Int) -> String {
        photoInformation.value[index].id
    }
    
}
