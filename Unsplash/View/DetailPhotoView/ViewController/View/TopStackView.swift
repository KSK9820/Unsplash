//
//  TopStackView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import UIKit

final class TopStackView: UIStackView {
    
    weak var delegate: TopStackViewDelegate?
    
    private var dataViewModel = DetailTopStackDataViewModel()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
        
        return button
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        
        if let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: descriptor, size: 0.0)
        }
        
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.addTarget(self, action: #selector(tappedDownload), for: .touchUpInside)
        
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .blue
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        setUI()
        configureStackViewUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - internal method
    
    func setContents(_ dataViewModel: DetailTopStackDataViewModel) {
        self.dataViewModel = dataViewModel
        userNameLabel.text = dataViewModel.userName
    }
    
    
    // MARK: - private method
    
    private func setUI() {
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 12
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStackViewUI() {
        self.addArrangedSubview(cancelButton)
        self.addArrangedSubview(userNameLabel)
        self.addArrangedSubview(downloadButton)
        self.addArrangedSubview(bookmarkButton)
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1.0),
            downloadButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            downloadButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1.0),
            bookmarkButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            bookmarkButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1.0),
        ])
    }
    
    @objc func tappedClose() {
        delegate?.closeView()
    }
    
    @objc func tappedDownload() {
        delegate?.checkAuthroization()
    }

}
