//
//  HotGamesViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-29.
//

import UIKit

class HotGamesViewController: UITableViewController {
    
    private var games: [Game] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }
    private let rowHeight: CGFloat = 290

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        getHotnessList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configure() {
        title = "Hot Games"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.frame = view.bounds
        tableView.rowHeight = rowHeight
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HotGameCell.self, forCellReuseIdentifier: HotGameCell.reuseID)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(getHotnessList), for: .valueChanged)
    }
    
    @objc private func getHotnessList() {
        NetworkManager.shared.getHotnessList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.games = games
                if games.count == 0 { self.showErrorAlertOnMainThread(message: UserError.generic.rawValue) }
            case .failure(let error):
                print("Error retrieving hotness list: \(error.rawValue)")
                self.showErrorAlertOnMainThread(message: UserError.generic.rawValue)
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

