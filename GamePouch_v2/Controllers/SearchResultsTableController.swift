//
//  SearchResultsTableController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-04.
//

import UIKit

class SearchResultsTableController: UITableViewController {
    
    var searchResults = [SearchResult]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as! SearchResultCell
        if let title = searchResults[indexPath.row].name {
            cell.setLabel(to: title)
        }
        return cell
    }
}
