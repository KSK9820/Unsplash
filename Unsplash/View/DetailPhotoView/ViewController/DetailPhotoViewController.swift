//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/22.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    private let id: String
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        
        UISetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - private method
    
    private func UISetting() {
        view.backgroundColor = .black
        view.alpha = 0.5
    }


}
