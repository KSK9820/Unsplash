//
//  SearchCollectionView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/02.
//

import UIKit

final class SearchCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - internal method
    
    
    
    
    // MARK: - private method
    
    private func setUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}

