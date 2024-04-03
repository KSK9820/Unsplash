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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        setUI()
        configureUI()
        bindData()
        hideKeyboardWhenTappedAround()
    }
    

    // MARK: - private method
    
    private func setUI() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        let layout = TwoColumnCollectionViewLayout()
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
                DispatchQueue.main.async {
                    self?.collectionView.saveSnapshot(result, section: .result)
                }
            }
        }
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension SearchPhotoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            viewModel.getSearchResult(keyword, page: "1")
        }
        
        searchBar.endEditing(true)
    }
}

extension SearchPhotoViewController: ListCollectinoViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        viewModel.getImageSize(row: indexPath.row, viewWidth: view.bounds.width)
    }
}
