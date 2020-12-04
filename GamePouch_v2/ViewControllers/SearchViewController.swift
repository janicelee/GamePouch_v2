//
//  SearchViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-29.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Hot Games"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

