//
//  TabBarController.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/07.
//

import UIKit

class TabBarController: UITabBarController {
    
    private lazy var leftTabBarItem: UITabBarItem = {
        let tabTabBarItem = UITabBarItem(
            title: "Tasks",
            image: UIImage(systemName: "checkmark.circle"),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")
        )
        
        return tabTabBarItem
    }()
    
    private lazy var rightTabBarItem: UITabBarItem = {
        let tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear")
        )
        
        return tabBarItem
    }()
    
    override func viewDidLoad() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemIndigo
        
        let todoListVC = TodoListViewController()
        todoListVC.tabBarItem = leftTabBarItem
        
        let settingVC = SettingViewController()
        settingVC.tabBarItem = rightTabBarItem
        
        viewControllers = [ todoListVC, settingVC ]
    }
}
