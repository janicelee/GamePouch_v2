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
        viewControllers = [createHotGamesNavigationController(), createSearchNavigationController(), createFavoritesNavigationController()]
    }
    
    private func createHotGamesNavigationController() -> UINavigationController {
        let hotgamesViewController = HotGamesViewController()
        hotgamesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        return UINavigationController(rootViewController: hotgamesViewController)
    }
    
    private func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return UINavigationController(rootViewController: searchViewController)
    }
    
    private func createFavoritesNavigationController() -> UINavigationController {
        let favoritesViewController = FavoritesTableViewController()
        favoritesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        return UINavigationController(rootViewController: favoritesViewController)
    }
}
