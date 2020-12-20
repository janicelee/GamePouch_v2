//
//  HotGamesViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-29.
//

import UIKit

class HotGamesViewController: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView()
    private var games: [Game] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getHotnessList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Hot Games"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 300
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameCell.self, forCellReuseIdentifier: GameCell.reuseID)
        tableView.removeExcessCells()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(getHotnessList), for: .valueChanged)
    }
    
    @objc private func getHotnessList() {
        NetworkManager.shared.getHotnessList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.games = games
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

extension HotGamesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseID) as! GameCell
        cell.set(game: games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        let destination = GameInfoViewController(game: game)
        
        navigationController?.pushViewController(destination, animated: true)
    }
}
