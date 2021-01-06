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
        viewControllers = [createHotGamesNavigationController(), createSearchNavigationController()]
    }
    
    private func createHotGamesNavigationController() -> UINavigationController {
        let hotgamesViewController = HotGamesViewController()
        hotgamesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        return UINavigationController(rootViewController: hotgamesViewController)
    }
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return UINavigationController(rootViewController: searchViewController)
    }
}
