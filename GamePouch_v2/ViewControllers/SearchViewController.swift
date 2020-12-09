//
//  SearchViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-29.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let tableView = UITableView()
    private var games: [Game] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getHotnessList()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Hot Games"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameCell.self, forCellReuseIdentifier: GameCell.reuseID)
        tableView.removeExcessCells()
    }
    
    private func getHotnessList() {
        NetworkManager.shared.getHotnessList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.games = games
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseID) as! GameCell
        cell.set(game: games[indexPath.row])
        return cell
    }
}
