//
//  TopStackView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import UIKit

class TopStackView: UIStackView {
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .white
        
        return button
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        
        if let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: descriptor, size: 0.0)
        }
        
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .blue
        
        return button
    }()
    
    
    init(_ viewModel: DetailPhotoViewModel) {
        super.init(frame: .zero)
        
        setUI()
        configureStackViewUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - private method
    private func setUI() {
        self.axis = .horizontal
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureStackViewUI() {
        self.addArrangedSubview(cancelButton)
        self.addArrangedSubview(userNameLabel)
        self.addArrangedSubview(downloadButton)
        self.addArrangedSubview(bookmarkButton)
    }

}
