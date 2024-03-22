//
//  MainPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import UIKit

final class MainPhotoViewController: UIViewController {
    
    private let viewModel = MainPhotoViewModel()
    
    private lazy var recentCollectionView = RecentImageCollectionView(viewModel, presenterDelegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UISetting()
        UIConfigure()

        currentPageBinding()
        totalPageBinding()
    }
    
    
    // MARK: - private method
    
    private func UISetting() {
        view.backgroundColor = .white
    }
    
    private func UIConfigure() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(recentCollectionView)        
        
        NSLayoutConstraint.activate([
            recentCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            recentCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            recentCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func totalPageBinding() {
        viewModel.totalPage.bind { _ in
            DispatchQueue.main.async {
                self.recentCollectionView.reloadData()
            }
        }
    }
    
    private func currentPageBinding() {
        viewModel.currentPage.bind { [weak self] _ in
            if self?.viewModel.currentPage.value == self?.viewModel.totalPage.value {
                self?.viewModel.getPhotoInformation()
            }
        }
    }
    
}


