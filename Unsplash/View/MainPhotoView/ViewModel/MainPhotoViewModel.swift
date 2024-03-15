//
//  MainPhotoViewModel.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/11.
//

import Foundation

public class MainPhotoViewModel: PhotoViewModelProtocol {
    
    private let serviceManager = PhotoServiceManager()
    
    var photoInformation = Binding<[MainPhotoDTO]>([])
    var photoList = Binding<[Data]>([])
    
    func getPhotos() {
        serviceManager.getMainPhotoList { [weak self] result in
            switch result {
            case .success(let datas):
                self?.photoInformation.value += datas
                for data in datas {
                    let url = data.urls.thumb
                    
                    self?.serviceManager.getPhoto(urlString: url) { [weak self] result in
                        switch result {
                        case .success(let ImageData):
                            self?.photoList.value.append(ImageData)
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
    
    func getPhotoCount() -> Int {
        return photoList.value.count
    }
    
    func getImageSize(row: Int, viewWidth: CGFloat) -> CGFloat {
        let image = photoInformation.value[row]
        let width = image.width
        let height = image.height
        
        return CGFloat(height * Int(viewWidth/2) / width)
    }
    
    func getThumbURLString(index: Int) -> String {
        photoInformation.value[index].urls.thumb
    }
    
}
