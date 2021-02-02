//
//  HotGamesViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-29.
//

import UIKit

class HotGamesViewController: UITableViewController {
    
    private var games: [Game] = []
    private let rowHeight: CGFloat = 290

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        getHotnessList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Hot Games"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.frame = view.bounds
        tableView.rowHeight = rowHeight
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HotGameCell.self, forCellReuseIdentifier: HotGameCell.reuseID)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(getHotnessList), for: .valueChanged)
    }
    
    @objc private func getHotnessList() {
        NetworkManager.shared.getHotnessList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.games = games
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl!.endRefreshing()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotGameCell.reuseID) as! HotGameCell
        cell.set(game: games[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        let destination = GameInfoViewController(game: game)
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! HotGameCell
        cell.clearImage()
    }
}

