//
//  TabBarController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-30.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createSearchNavigationController()]
    }
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = HotGamesViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchViewController)
    }
    
}
