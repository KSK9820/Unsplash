//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import UIKit

final class DetailPhotoViewController: UIViewController {
    
    private let viewModel = DetailPhotoViewModel()
    private let id: String
    
    private var topStackView = TopStackView()
    private var imageView = DetailImageView(frame: .zero)
    private var bottomStackView = BottomStackView()
    
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
        bindData()
    }
    
    
    // MARK: - private method
    
    private func setUI() {
        topStackView.delegate = self
        
        //        view.backgroundColor = .black
        //        view.alpha = 0.5
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(topStackView)
        view.addSubview(imageView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            topStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            topStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            bottomStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            bottomStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func bindData() {
        viewModel.topStackViewDTO.bind { _ in
            DispatchQueue.main.async {
                self.topStackView.setContents(self.viewModel.topStackViewDTO.value)
            }
        }
        
        viewModel.height.bind { _ in
            if let imageURL = self.viewModel.imageURL {
                self.imageView.setContents(imageURL)
                DispatchQueue.main.async {
                    self.imageView.heightAnchor.constraint(equalToConstant: self.viewModel.height.value * self.view.frame.width).isActive = true
                }
            }
        }
        
        viewModel.bottomStackViewDTO.bind { _ in
            DispatchQueue.main.async {
                self.bottomStackView.setContents(self.viewModel.bottomStackViewDTO.value)
            }
        }
    }
    
}


// MARK: - StackViewDataDelegate method

extension DetailPhotoViewController: StackViewDataDelegate {
    
    func closeView() {
        navigationController?.popViewController(animated: true)
    }
    
}
