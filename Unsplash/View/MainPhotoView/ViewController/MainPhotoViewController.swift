//
//  MainPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import UIKit

final class MainPhotoViewController: UIViewController {
    
    private let viewModel = MainPhotoViewModel()
    
    private lazy var recentCollectionView = RecentImageCollectionView(viewModel: viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UISetting()
        UIConfigure()

        currentPageBinding()
        photoInformationBinding()
        totalPageBinding()
    }
    
    
    // MARK: - private method
    
    private func UISetting() {
        view.backgroundColor = .white
    }
    
    private func UIConfigure() {
        view.addSubview(recentCollectionView)
        
        NSLayoutConstraint.activate([
            recentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            recentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func photoInformationBinding() {
        viewModel.photoInformation.bind { _ in
            DispatchQueue.main.async {
                self.recentCollectionView.reloadData()
            }
        }
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


