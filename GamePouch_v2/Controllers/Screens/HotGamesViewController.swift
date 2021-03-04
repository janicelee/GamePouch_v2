//
//  HotGamesViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-11-29.
//

import UIKit

class HotGamesViewController: UITableViewController {
    
    private let rowHeight: CGFloat = 290
    
    private var games: [Game] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getHotnessList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func getHotnessList() {
        BoardGameGeekClient.shared.getHotnessList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let games):
                self.games = games
                if games.count == 0 { self.presentErrorAlertOnMainThread(message: InternalError.generic.rawValue) }
            case .failure(let error):
                self.presentErrorAlertOnMainThread(message: InternalError.generic.rawValue)
                print("Error retrieving hotness list: \(error.rawValue)")
            }
        }
    }
    
    @objc private func moreInfoTapped() {
        let detailedInfoViewController = LegendInfoViewController()
        detailedInfoViewController.modalPresentationStyle = .overFullScreen
        detailedInfoViewController.modalTransitionStyle = .crossDissolve
        present(detailedInfoViewController, animated: true)
    }
    
    // MARK: - Configuration
    
    private func configure() {
        title = "Hot Games"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let moreInfoButton = UIButton(type: .infoLight)
        moreInfoButton.addTarget(self, action: #selector(moreInfoTapped), for: .touchUpInside)
        moreInfoButton.tintColor = Colors.purple
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreInfoButton)
        
        tableView.frame = view.bounds
        tableView.rowHeight = rowHeight
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HotGameCell.self, forCellReuseIdentifier: HotGameCell.reuseID)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(getHotnessList), for: .valueChanged)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HotGameCell.reuseID) as! HotGameCell
        cell.set(game: games[indexPath.row])
        cell.delegate = self
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

// MARK: - HotGameCellDelegate

extension HotGamesViewController: HotGameCellDelegate {
    
    func didFailToUpdateFavorite(id: String, error: Error) {
        presentErrorAlertOnMainThread(message: InternalError.generic.rawValue)
    }
    
    func didSelectCell(game: Game) {
        let destination = GameInfoViewController(game: game)
        navigationController?.pushViewController(destination, animated: true)
    }
}
