//
//  RecentImageCollectionView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/19.
//

import UIKit

final class RecentImageCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - private method
    
    private func configureUI() {
        self.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.reuseIdentifier)
        self.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
