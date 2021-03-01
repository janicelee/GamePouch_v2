//
//  FavoritesTableViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-13.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    let emptyStateView = EmptyFavoritesView()
    private let rowHeight: CGFloat = 70
    
    var games: [Game] = [] { didSet { updateUI() } }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        
        configureEmptyStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites() 
    }
    
    private func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
        }
    }
    
    private func fetchFavorites() {
        CoreDataClient.shared.fetchFavoriteGames { [weak self] gamesResult in
            guard let self = self else { return }
            
            switch gamesResult {
            case .success(let games):
                self.games = games
            case .failure(let error):
                self.presentErrorAlertOnMainThread(message: error.getErrorMessage())
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            if self.games.isEmpty {
                UIView.transition(with: self.emptyStateView, duration: 0.3, options: .transitionCrossDissolve) {
                    self.emptyStateView.isHidden = false
                }
            } else {
                self.emptyStateView.isHidden = true
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
                try CoreDataClient.shared.deleteFavoriteGame(id: id)
                games.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error {
                presentErrorAlertOnMainThread(message: error.getErrorMessage())
            }
        }
    }
}
