//
//  FavoritesTableViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-13.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    private let rowHeight: CGFloat = 70
    
    var games: [Game] = [] {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites() 
    }
    
    private func fetchFavorites() {
        PersistenceManager.fetchFavorites { [weak self] gamesResult in
            guard let self = self else { return }
            
            switch gamesResult {
            case .success(let games):
                self.games = games
            case .failure(let error):
                self.presentErrorAlertOnMainThread(message: error.getErrorMessage())
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
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
        let cell = cell as! FavoriteCell
        cell.clearImage()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = games[indexPath.row].id else {
                presentErrorAlertOnMainThread(message: InternalError.unableToDeleteFavorite.getErrorMessage())
                return
            }
            
            do {
                try PersistenceManager.deleteFavorite(gameId: id)
                games.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error {
                presentErrorAlertOnMainThread(message: error.getErrorMessage())
            }
        }
    }
}
