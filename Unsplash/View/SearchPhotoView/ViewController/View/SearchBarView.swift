//
//  SearchBarView.swift
//  Unsplash
//
//  Created by 김수경 on 2024/04/02.
//

import UIKit

final class SearchBarView: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - private method
    
    private func setUI() {
        placeholder = "검색어를 입력해주세요"
        translatesAutoresizingMaskIntoConstraints = false
        searchBarStyle = .minimal
        searchTextField.backgroundColor = .clear
    }
}
