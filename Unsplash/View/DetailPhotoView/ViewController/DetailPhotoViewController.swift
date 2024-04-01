//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import UIKit
import Photos

final class DetailPhotoViewController: UIViewController {
    
    private let viewModel = DetailPhotoViewModel()
    private let imageConverter = ImageConverter()
    private let id: String
    
    private let topStackView = TopStackView()
    private let imageView = DetailImageView(frame: .zero)
    private let bottomStackView = BottomStackView()
    
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
        viewModel.topStackDataViewModel.bind { [weak self] data in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let viewModel = data else { return }
                self.topStackView.setContents(viewModel)
            }
        }
        
        viewModel.imageViewDataViewModel.bind { [weak self] data in
            guard let viewModel = data else { return }
            if let imageURL = viewModel.imageURL {
                guard let self = self else { return }
                
                imageView.setContents(imageURL)
                
                DispatchQueue.main.async {
                    if let aspectRatio = viewModel.aspectRatioOfHeight {
                        self.imageView.heightAnchor.constraint(equalToConstant: aspectRatio * self.view.frame.width).isActive = true
                    }
                }
            }
        }
        
        viewModel.bottomStackDataViewModel.bind { [weak self] data in
            guard let viewModel = data else { return }
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.bottomStackView.setContents(viewModel)
            }
        }
        
        viewModel.downloadURL.bind { url in
            guard let urlString = url else { return }
            self.imageConverter.getImage(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.alertDownloaded), nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func notifyNoAuthroization() {
        let authorizationAlert = DownloadAlertViewController(message: "갤러리 접근 권한이 없습니다.")
        authorizationAlert.setBackgroundColor(.white)
        authorizationAlert.showAlert(from: self)
    }
    
    private func downloadImage() {
        if let id = viewModel.photoInformation?.id {
            viewModel.downloadPhoto(id: id)
        }
    }
    
    @objc func alertDownloaded(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        let message = error == nil ? "이미지를 다운로드 하였습니다." : "다운로드에 실패하였습니다."
        let successAlert = DownloadAlertViewController(message: message)
        
        successAlert.showAlert(from: self)
    }
    
}


// MARK: - StackViewDataDelegate method

extension DetailPhotoViewController: TopStackViewDelegate {
    
    func closeView() {
        navigationController?.popViewController(animated: true)
    }

    func checkAuthroization() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] PHAuthorizationStatus in
            switch PHAuthorizationStatus {
            case .authorized:
                self?.downloadImage()
            default:
                DispatchQueue.main.async {
                    self?.notifyNoAuthroization()
                }
            }
        }
    }
    
}
