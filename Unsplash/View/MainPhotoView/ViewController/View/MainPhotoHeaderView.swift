//
//  MainPhotoHeaderView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/21.
//

import UIKit

final class MainPhotoHeaderView: UICollectionReusableView, ReuseIdentifiable {

    private var headerTitle: UILabel = {
        let label = UILabel()
        
        if let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: descriptor, size: 0.0)
        }
        
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHeaderViewUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - internal method
    
    func setTitle(with title: String) {
        headerTitle.text = title
    }

    
    // MARK: - private method
    
    private func configureHeaderViewUI() {
        addSubview(headerTitle)
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: topAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }

}
