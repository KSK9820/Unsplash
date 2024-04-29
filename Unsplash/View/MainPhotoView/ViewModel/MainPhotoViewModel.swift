//
//  MainPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/11.
//

import Foundation

final class MainPhotoViewModel: PhotoViewModelProtocol {
    
    private let serviceManager = PhotoServiceManager()
    
    private(set) var photoInformation = Binding<[MainPhotoResponse]>([])
    private var currentPage = 0
    private var totalPage = 1
    
    var fetchNextpage: Bool {
        currentPage < totalPage
    }
    
    var insertItemRange: Range<Int> {
        return ((currentPage-1) * 10..<currentPage * 10)
    }
    
    func getPhotoInformation() {
        currentPage += 1
        
        serviceManager.getRecentPhotoList(page: String(totalPage)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoInformation.value += data
                self?.totalPage += 1
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
    
    func getPhotoID(index: Int) -> String {
        photoInformation.value[index].id
    }
    
}
