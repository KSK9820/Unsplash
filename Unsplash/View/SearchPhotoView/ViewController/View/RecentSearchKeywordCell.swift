//
//  RecentSearchKeywordCell.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/05.
//

import UIKit

final class RecentSearchKeywordCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = true
        
        return label
    }()
    
    func setLabelText(_ text: String) {
        label.text = text
    }
}
