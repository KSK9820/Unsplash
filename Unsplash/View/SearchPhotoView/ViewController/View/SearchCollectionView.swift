//
//  SearchCollectionView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/02.
//

import UIKit

final class SearchCollectionView: UICollectionView {

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SearchSection, MainPhotoDTO>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    private typealias ImageCellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, MainPhotoDTO>
    
    private var diffableDataSource: DiffableDataSource?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        setUI()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - internal method
    
    func saveSnapshot(_ result: [MainPhotoDTO], section: SearchSection) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, MainPhotoDTO>()
        snapshot.appendSections([section])
        snapshot.appendItems(result, toSection: section)
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }


    // MARK: - private method
    
    private func setUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureDataSource() {
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
        }
        
        let cellRegistration = ImageCellRegistration { cell, indexPath, itemIdentifier in
            cell.setImage(urlString: itemIdentifier.urls.thumb)
        }
        
        diffableDataSource = DiffableDataSource(collectionView: self, cellProvider: { 
            collectionView, indexPath, itemIdentifier in
    
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        })

        diffableDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            
            if collectionView.numberOfItems(inSection: 0) > 0 {
                header.setTitle(with: "검색 결과")
            }
            
            return header
        }
        
        saveSnapshot([], section: .result)
    }
}




enum SearchSection {
    case result
    case recentKeyword
}

