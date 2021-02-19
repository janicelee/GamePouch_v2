//
//  SearchResultsTableController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-04.
//

import UIKit

protocol SearchResultsTableControllerDelegate: class {
    func didSelectSearchResult(result: SearchResult)
}

class SearchResultsTableController: UITableViewController {
    
    weak var delegate: SearchResultsTableControllerDelegate?
    var searchResults = [SearchResult]() {
        didSet { DispatchQueue.main.async { self.tableView.reloadData() }}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
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
        delegate?.didSelectSearchResult(result: searchResult)
    }
}

extension SearchResultsTableController: SearchResultCellDelegate {
    
    func didSelectSearchResult(_ searchResult: SearchResult) {
        delegate?.didSelectSearchResult(result: searchResult)
    }
}
