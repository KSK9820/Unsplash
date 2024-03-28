//
//  BottomStackView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/27.
//

import UIKit

final class BottomStackView: UIStackView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        configureStackViewUI()
    }
   
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal method
    
    func setContents(_ dto: DetailBottomStackViewDTO) {
        titleLabel.text = dto.title
        descriptionLabel.text = dto.description

        var tagValue = ""
        if let tags = dto.tag {
            for tag in tags {
                tagValue += "#\(tag.title) "
            }
        }
        tagLabel.text = tagValue
    }

    
    // MARK: - private method
    
    private func setUI() {
        self.axis = .vertical
        self.alignment = .leading
        self.spacing = 12
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStackViewUI() {
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(descriptionLabel)
        self.addArrangedSubview(tagLabel)
    }
    
}
