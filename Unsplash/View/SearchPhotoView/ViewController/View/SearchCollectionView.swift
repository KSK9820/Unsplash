//
//  SearchCollectionView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/02.
//

import UIKit

final class SearchCollectionView: UICollectionView {

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SearchSection, AnyHashable>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    private typealias RecentSearchKeywordCellRegistration = UICollectionView.CellRegistration<RecentSearchKeywordCell, String>
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
    
    func saveSnapshot(keyword: [String]?, image: [MainPhotoDTO]?) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, AnyHashable>()
        if let searchKeyword = keyword{
            snapshot.appendSections([.recentKeyword])
            snapshot.appendItems(searchKeyword, toSection: .recentKeyword)
        }
        if let searchImage = image {
            snapshot.appendSections([.result])
            snapshot.appendItems(searchImage, toSection: .result)
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    

    // MARK: - private method
    
    private func setUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
    }

    private func configureDataSource() {
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
        }
        let keywordCellRegistration = RecentSearchKeywordCellRegistration { cell, indexPath, itemIdentifier in
            DispatchQueue.main.async {
                cell.setLabelText(itemIdentifier)
            }
        }
        let imageCellRegistration = ImageCellRegistration { cell, indexPath, itemIdentifier in
            cell.setImage(urlString: itemIdentifier.urls.thumb)
        }
        
        diffableDataSource = DiffableDataSource(collectionView: self, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            
            switch indexPath.section {
            case 0:
                return collectionView.dequeueConfiguredReusableCell(
                    using: keywordCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? String
                )
            case 1:
                return collectionView.dequeueConfiguredReusableCell(
                    using: imageCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? MainPhotoDTO
                )
            default:
                return nil
            }
            
        })

        diffableDataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            
            switch indexPath.section {
            case 0:
                if collectionView.numberOfItems(inSection: 0) > 0 {
                    header.setTitle(with: "최근 검색어")
                }
            case 1:
                if collectionView.numberOfItems(inSection: 1) > 0 {
                    header.setTitle(with: "검색 결과")
                }
            default:
                break
            }
            
            return header
        }
        
        saveSnapshot(keyword: [], image: [])
    }
}

enum SearchSection {
    case result
    case recentKeyword
}

