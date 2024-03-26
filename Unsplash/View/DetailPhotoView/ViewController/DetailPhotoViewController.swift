//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    private let viewModel = DetailPhotoViewModel()
    private let id: String
    
    private lazy var topStackView = TopStackView(viewModel)
    
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.getPhotoInformation(id: id)

        setUI()
        configureUI()
        
        
    }
    
    
    // MARK: - private method
    
    private func setUI() {
        view.backgroundColor = .black
        view.alpha = 0.5
    }

    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(topStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            topStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    

}
