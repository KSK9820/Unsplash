//
//  MainPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import UIKit

final class MainPhotoViewController: UIViewController {
    
    private let viewModel = MainPhotoViewModel()
    
    private var recentCollectionView = RecentImageCollectionView()
    
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
        
        let layout = MainPhotoCollectionViewLayout()
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
        viewModel.photoInformation.bind { [weak self] _ in
            DispatchQueue.main.async {
                if self?.viewModel.getPhotoCount() ?? 0 <= 10 {
                    self?.recentCollectionView.reloadData()
                } else {
                    self?.recentCollectionView.performBatchUpdates({
                        if let indexPath = self?.viewModel.insertItemRange.map({ IndexPath(item: $0, section: 0) }) {
                            self?.recentCollectionView.insertItems(at: indexPath)
                        }
                    }, completion: nil)
                }
            }
        }
    }
    
}


// MARK: - UICollectionViewDelegate method

extension MainPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPhotoViewController = DetailPhotoViewController(id: viewModel.getPhotoID(index: indexPath.row))
        
        self.navigationController?.pushViewController(detailPhotoViewController, animated: false)
    }
}


// MARK: - UICollectionViewDataSource method

extension MainPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getPhotoCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return ImageCollectionViewCell()
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
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeaderView.reuseIdentifier, for: indexPath) as? CollectionViewHeaderView else {
                return CollectionViewHeaderView()
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

extension MainPhotoViewController: TwoColumnCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.getImageSize(row: indexPath.row, viewWidth: view.bounds.width)
    }
    
}

