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
        checkAccessibilityForGallery()
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
        viewModel.topStackViewDTO.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.topStackView.setContents(self.viewModel.topStackViewDTO.value)
            }
        }
        
        viewModel.height.bind { [weak self] _ in
            if let imageURL = self?.viewModel.imageURL {
                self?.imageView.setContents(imageURL)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.imageView.heightAnchor.constraint(equalToConstant: self.viewModel.height.value * self.view.frame.width).isActive = true
                }
            }
        }
        
        viewModel.bottomStackViewDTO.bind { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.bottomStackView.setContents(self.viewModel.bottomStackViewDTO.value)
            }
        }
    }
    
    private func checkAccessibilityForGallery() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] PHAuthorizationStatus in
            switch PHAuthorizationStatus {
            case .authorized:
                guard let self = self else { return }
                viewModel.downloadURL.bind { _ in
                    if self.viewModel.downloadURL.value == String() { return }
       
                    self.imageConverter.getImage(urlString: self.viewModel.downloadURL.value) { result in
                        switch result {
                        case .success(let data):
                            if let image = UIImage(data: data) {
                                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.alertDownloaded), nil)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
    @objc func alertDownloaded(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        var message = error == nil ? "이미지를 다운로드 하였습니다." : "다운로드에 실패하였습니다."
        let successAlert = DownloadAlertViewController(message: message)
        
        successAlert.showAlert(from: self)
    }
}


// MARK: - StackViewDataDelegate method

extension DetailPhotoViewController: StackViewDataDelegate {
    
    func closeView() {
        navigationController?.popViewController(animated: true)
    }
    
    func download() {
        if let id = viewModel.photoInformation?.id {
            viewModel.downloadPhoto(id: id)
        }
    }
}
