//
//  SearchResultsTableController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-04.
//

import UIKit

protocol SearchResultsTableViewControllerDelegate: class {
    func didSelectSearchResult(searchResult: SearchResult)
}

class SearchResultsTableViewController: UITableViewController {
    
    private var searchResults = [SearchResult]() {
        didSet { DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    weak var delegate: SearchResultsTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
    }
    
    func setSearchResults(_ searchResults: [SearchResult]) {
        self.searchResults = searchResults
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as! SearchResultCell
        cell.set(searchResult: searchResults[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        delegate?.didSelectSearchResult(searchResult: searchResult)
    }
}

// MARK: - SearchResultCellDelegate

extension SearchResultsTableViewController: SearchResultCellDelegate {
    
    func didSelectSearchResult(_ searchResult: SearchResult) {
        delegate?.didSelectSearchResult(searchResult: searchResult)
    }
}
