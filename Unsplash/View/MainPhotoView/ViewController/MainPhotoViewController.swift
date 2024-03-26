//
//  MainPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import UIKit

final class MainPhotoViewController: UIViewController {
    
    private let viewModel = MainPhotoViewModel()
    
    private lazy var recentCollectionView = RecentImageCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUI()
        configureUI()
        
        viewModel.getPhotoInformation()
        bindData()
    }
    
    
    // MARK: - private method
    
    private func setUI() {
        view.backgroundColor = .white
        
        let layout = RecentCollectionViewLayout()
        layout.delegate = self
        recentCollectionView.collectionViewLayout = layout
        
        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        recentCollectionView.prefetchDataSource = self
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(recentCollectionView)        
        
        NSLayoutConstraint.activate([
            recentCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recentCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recentCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func bindData() {
        viewModel.photoInformation.bind { _ in
            DispatchQueue.main.async {
                self.recentCollectionView.reloadData()
            }
        }
    }

}


// MARK: - UICollectionViewDelegate method

extension MainPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPhotoViewControoler = DetailPhotoViewController(id: viewModel.getPhotoID(index: indexPath.row))
    
        self.navigationController?.pushViewController(detailPhotoViewControoler, animated: true)
    }
}


// MARK: - UICollectionViewDataSource method

extension MainPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getPhotoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier, for: indexPath) as? RecentImageCollectionViewCell else {
            return RecentImageCollectionViewCell()
        }
        
        cell.backgroundColor = UIColor.systemGray
        cell.setImage(urlString: viewModel.getThumbURLString(index: indexPath.row))
        
        if let description = viewModel.photoInformation.value[indexPath.row].altDescription {
            cell.setTitle(string: description)
        } else if let description = viewModel.photoInformation.value[indexPath.row].description {
            cell.setTitle(string: description)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MainPhotoHeaderView.reuseIdentifier, for: indexPath) as? MainPhotoHeaderView else {
                return MainPhotoHeaderView()
            }
            
            headerView.setTitle(with: "최신 이미지")
           
            return headerView
        default:
            assert(false)
        }
    }
}


// MARK: - UICollectionViewDataSourcePrefetching method

extension MainPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.getPhotoCount() - 5 < indexPath.item && viewModel.fetchNextpage {
                viewModel.getPhotoInformation()
            }
        }
    }
}


// MARK: - Recent Photo Layout Delegate method

extension MainPhotoViewController: RecentCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.getImageSize(row: indexPath.row, viewWidth: view.bounds.width)
    }
    
}
