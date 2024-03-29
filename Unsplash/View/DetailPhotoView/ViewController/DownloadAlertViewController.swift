//
//  DownloadAlertViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/29.
//

import UIKit

class DownloadAlertViewController: UIViewController {
    
    private let message: String?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message

        return label
    }()
    
    init(message: String?) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        configureUI()
    }
    
    
    // MARK: - internal method

    func showAlert(from parent: UIViewController) {
        self.view.alpha = 0
        
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.didMove(toParent: parent)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: parent.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: parent.view.centerYAnchor),
            view.widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 1.3),
            view.heightAnchor.constraint(equalTo: label.heightAnchor, multiplier: 2.0)
        ])
        
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 0.7
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1.0) {
                    self.view.alpha = 0
                } completion: { _ in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                }
            }
        }
    }
    

    // MARK: - private method
    
    private func setUI() {
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        
    }

    private func configureUI() {
        view.addSubview(label)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
}
