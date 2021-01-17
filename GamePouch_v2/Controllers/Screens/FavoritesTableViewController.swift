//
//  FavoritesTableViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-13.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    var favorites: [NSManagedObject] = [] {
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
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PersistenceManager.fetchFavorites { [weak self] asyncFetchResult in
            guard let self = self else { return }
            
            if let result = asyncFetchResult.finalResult {
                self.favorites = result
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.set(favorite: favorites[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
