//
//  DetailImageView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/27.
//

import UIKit

final class DetailImageView: UIImageView {
    
    private let imageConverter = ImageConverter()
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - internal method

    func setContents(_ urlString: String) {
        imageConverter.getImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)     
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
