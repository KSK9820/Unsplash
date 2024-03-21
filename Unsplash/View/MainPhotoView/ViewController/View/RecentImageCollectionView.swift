//
//  RecentImageCollectionView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/19.
//

import UIKit

final class RecentImageCollectionView: UICollectionView {

    private let viewModel: MainPhotoViewModel
    
    init(viewModel: MainPhotoViewModel) {
        self.viewModel = viewModel
    
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - private method
    
    private func configuration() {
        let layout = RecentCollectionViewLayout()
        layout.delegate = self

        self.collectionViewLayout = layout
        self.register(RecentImageCollectionViewCell.self, forCellWithReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier)
        self.dataSource = self
        self.prefetchDataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}


// MARK: - UICollectionViewDataSource method

extension RecentImageCollectionView: UICollectionViewDataSource {
    
    // pagination 오류
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getPhotoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier, for: indexPath) as? RecentImageCollectionViewCell else {
            return RecentImageCollectionViewCell()
        }
        
        cell.backgroundColor = UIColor.systemGray
        cell.setImage(urlString: viewModel.getThumbURLString(index: indexPath.row))
        
        return cell
    }
    
}


extension RecentImageCollectionView: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.getPhotoCount() - 5 < indexPath.item && viewModel.currentPage.value < viewModel.totalPage.value {
                viewModel.fetchNextPage()
            }
        }
    }
    
}


// MARK: - Recent Photo Layout Delegate method

extension RecentImageCollectionView: RecentCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.getImageSize(row: indexPath.row, viewWidth: self.layer.bounds.width)
    }
    
}
