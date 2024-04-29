//
//  SearchPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/01.
//

import UIKit

final class SearchPhotoViewController: UIViewController {

    private let viewModel = SearchPhotoViewModel()
    
    private let searchBar = SearchBarView()
    private let collectionView = SearchCollectionView()
    private var dataSource: DiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        setUI()
        configureUI()
        bindData()
        configureDataSource()

        addKeyboardGesture()
    }
    

    // MARK: - private method
    
    private func setUI() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        let layout = SearchPhotoCollectionViewLayout()
        layout.delegate = self
        
        collectionView.collectionViewLayout = layout
    }
    
    private func configureUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
        
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    private func bindData() {
        viewModel.searchResult.bind { [weak self] searchResult in
            if let result = searchResult?.results {
                DispatchQueue.main.async { [weak self] in
                    self?.saveNewSnapshot(keyword: self?.viewModel.searchKeyword.value, image: result)
                }
            }
        }
        
        viewModel.searchKeyword.bind { [weak self] searchKeyword in
            DispatchQueue.main.async {

            }
        }
    }
    
    private func addKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}


// MARK: - UICollectionView Diffable DataSource

extension SearchPhotoViewController {
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SearchSection, SearchSectionItem>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionViewHeaderView>
    private typealias RecentSearchKeywordCellRegistration = UICollectionView.CellRegistration<RecentSearchKeywordCell, String>
    private typealias ImageCellRegistration = UICollectionView.CellRegistration<ImageCollectionViewCell, SearchResultDTO>
    
   
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
        
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .recentKeywordItem(let data):
                return collectionView.dequeueConfiguredReusableCell(
                    using: keywordCellRegistration,
                    for: indexPath,
                    item: data
                )
            case .imageItem(let data):
                return collectionView.dequeueConfiguredReusableCell(
                    using: imageCellRegistration,
                    for: indexPath,
                    item: data
                )
            }
            
        })

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            let section = SearchSection(rawValue: indexPath.section)

            switch section {
            case .recentKeyword:
                    header.setTitle(with: section?.title)
            case .image:
                    header.setTitle(with: section?.title)
            default:
                break
            }
            
            return header
        }
        
        let snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchSectionItem>()
//        snapshot.appendSections([.recentKeyword, .image])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func saveNewSnapshot(keyword: [String]?, image: [SearchResultDTO]?) {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchSectionItem>()
        snapshot.appendSections([.recentKeyword, .image])
        
        if let keyword = keyword {
            let searchKeyword = keyword.map { SearchSectionItem.recentKeywordItem($0) }
            snapshot.appendItems(searchKeyword, toSection: .recentKeyword)
        }
        
        if let image = image {
            let searchImage = image.map { SearchSectionItem.imageItem($0) }
            snapshot.appendItems(searchImage, toSection: .image)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func appendSnapshot(image: [SearchResultDTO]?) {
        guard var currentSnapshot = dataSource?.snapshot() else { return }
    
        if let image = image {
            let searchImage = image.map { SearchSectionItem.imageItem($0) }
            currentSnapshot.appendItems(searchImage, toSection: .image)
        }
        dataSource?.apply(currentSnapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionView Registration Section and Item Enum

enum SearchSection: Int, CaseIterable {
    case recentKeyword
    case image
    
    var title: String {
        switch self {
        case .recentKeyword:
            return "최근 검색어"
        case .image:
            return "검색 결과"
        }
    }
}

enum SearchSectionItem: Hashable {
    case recentKeywordItem(String)
    case imageItem(SearchResultDTO)
}


// MARK: - SearchBar

extension SearchPhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            viewModel.searchKeywordImage(keyword, page: "1")
            viewModel.saveSearchKeyword(keyword)
        }
        searchBar.endEditing(true)
    }
}


// MARK: - UICollectionViewLayout

extension SearchPhotoViewController: TwoColumnCollectionViewLayoutDelegate {
   
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        viewModel.getImageSize(row: indexPath.row, viewWidth: view.bounds.width)
    }
}
