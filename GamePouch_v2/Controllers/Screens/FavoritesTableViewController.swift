//
//  FavoritesTableViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-13.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    private let rowHeight: CGFloat = 90
    
    var favorites: [Game] = [] {
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
                var favorites: [Game?] = Array(repeating: nil, count: fetchResult.count)
                let group = DispatchGroup()
                
                for (index, object) in fetchResult.enumerated() {
                    group.enter()
                    
                    if let id = object.value(forKeyPath: "id") as? String {
                        NetworkManager.shared.getGameInfo(id: id) { result in
                            switch result {
                            case .success(let game):
                                favorites.insert(game, at: index)
                            case .failure(let error):
                                print("Error retrieving game info for favorite with id: \(id), error: \(error.rawValue)")
                            }
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.favorites = favorites.compactMap{$0}
                    // TODO: check num NSManagedObjects in fetchResult vs. favorites, show prompt that not all favorites could retrieve their data
                }
            } else {
                // TODO: show error that favorites could not be retrieved successfully
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.set(game: favorites[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destination = GameInfoViewController(game: favorite)
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! FavoriteCell
        cell.resetImage()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = favorites[indexPath.row].id else { return }
            PersistenceManager.deleteFavorite(gameId: id)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    */
}
