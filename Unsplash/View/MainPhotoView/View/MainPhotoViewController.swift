//
//  MainPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import UIKit

final class MainPhotoViewController: UIViewController {
    
    private let viewModel = MainPhotoViewModel()
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecentCollectionViewLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RecentImageCollectionViewCell.self, forCellWithReuseIdentifier: RecentImageCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    func UISetting() {
        if let layout = collectionView.collectionViewLayout as? RecentCollectionViewLayout {
          layout.delegate = self
        }
        
        collectionView.dataSource = self
    }
    
    func UIConfigure() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        UISetting()
        UIConfigure()
        
        viewModel.getPhotos()
     
        viewModel.photoList.bind { [weak self] photoList in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
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
        
        cell.setImage(imageData: viewModel.photoList.value[indexPath.row])
    
        return cell
    }
    
}


// MARK: - Recent Photo Layout Delegate method

extension MainPhotoViewController: RecentCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPaht indexPath: IndexPath) -> CGFloat {
        viewModel.getImageSize(row: indexPath.row, viewWidth: view.bounds.width)
    }
    
}

