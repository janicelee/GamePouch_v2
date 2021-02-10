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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        PersistenceManager.fetchFavorites { [weak self] asyncFetchResult in
            guard let self = self else { return }
            
            if let fetchResult = asyncFetchResult.finalResult {
                var games: [Game?] = Array(repeating: nil, count: fetchResult.count)
                let group = DispatchGroup()
                
                for (index, object) in fetchResult.enumerated() {
                    group.enter()
                    
                    if let id = object.value(forKeyPath: "id") as? String {
                        NetworkManager.shared.getGameInfo(id: id) { result in
                            switch result {
                            case .success(let game):
                                games.insert(game, at: index)
                            case .failure(let error):
                                print("Error retrieving game info for favorite with id: \(id), error: \(error.rawValue)")
                            }
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.games = games.compactMap{$0}
                    if self.games.count == 0 { self.showErrorAlertOnMainThread(message: "Could not retrieve favorites") }
                    if self.games.count != fetchResult.count { self.showErrorAlertOnMainThread(message: "Could not retrieve all favorites") }
                }
            } else {
                // TODO: show error that favorites could not be retrieved successfully
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
            guard let id = games[indexPath.row].id else { return }
            PersistenceManager.deleteFavorite(gameId: id)
            games.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
