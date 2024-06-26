//
//  TabBarViewController.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/07.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstView = UINavigationController(rootViewController: UIViewController())
        let secondView = UINavigationController(rootViewController: MainPhotoViewController())
        let thirdView = UINavigationController(rootViewController: SearchPhotoViewController())
        
        secondView.navigationBar.isHidden = true
        thirdView.navigationBar.isHidden = true
        
        firstView.tabBarItem = UITabBarItem(title: "random", image: UIImage(systemName: "photo.on.rectangle.angled"), tag: 0)
        secondView.tabBarItem = UITabBarItem(title: "main", image: UIImage(systemName: "house.fill"), tag: 1)
        thirdView.tabBarItem = UITabBarItem(title: "search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
    
        self.setViewControllers([firstView, secondView, thirdView], animated: false)
        self.tabBar.backgroundColor = .black
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = .darkGray
        
        self.selectedIndex = 2
    }

}
