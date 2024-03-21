//
//  RecentImageCollectionViewCell.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/12.
//

import UIKit

final class RecentImageCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
    private let imageConverter = ImageConverter()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10 
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - internal method
    
    func setImage(urlString: String) {
        imageConverter.getImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: imageData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - private method

    private func configure() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
