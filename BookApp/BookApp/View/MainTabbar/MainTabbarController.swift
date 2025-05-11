//
//  MainTabbarController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit

final class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let firstVC = SearchViewController()
        let secondVC = MyBookViewController()
        firstVC.tabBarItem.title = "검색 탭"
        secondVC.tabBarItem.title = "담은 책 리스트 탭"
        self.viewControllers = [firstVC, secondVC]
        
    }

}

