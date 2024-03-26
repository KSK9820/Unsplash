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
        self.register(MainPhotoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainPhotoHeaderView.reuseIdentifier)
        self.register(RecentImageCollectionViewCell.self, forCellWithReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
