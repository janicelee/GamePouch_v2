//
//  SearchViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-02.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var searchController: UISearchController!
    private var resultsTableController: SearchResultsTableController!
    private var recentSearchTableController: RecentSearchTableController!
    
    private var lastSearchText : String?
    private var debouncedSearch: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        debouncedSearch = debounce(interval: 200) {
            self.getSearchResults(for: self.lastSearchText!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = resultsTableController.tableView.indexPathForSelectedRow {
            resultsTableController.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func configure() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        resultsTableController = SearchResultsTableController()
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a game"
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        recentSearchTableController = RecentSearchTableController()
        addChild(recentSearchTableController)
        view.addSubview(recentSearchTableController.view)
        recentSearchTableController.didMove(toParent: self)
        
        recentSearchTableController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func getSearchResults(for text: String) {
        print("searching for: \(text)")
        
        NetworkManager.shared.search(for: text) { [weak self] result in
            guard let self = self else { return }
            
            if text == self.lastSearchText {
                
                print("displaying results for: \(text)")
                switch result {
                case .success(let searchResults):
                    self.resultsTableController.searchResults = searchResults
                case .failure(let error):
                    print(error.rawValue)
                    // TODO: display error
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = resultsTableController.searchResults[indexPath.row]
        
        if let id = searchResult.id {
            NetworkManager.shared.getGameInfo(id: id) { result in
                switch result {
                case .success(let game):
                    DispatchQueue.main.async {
                        let gameInfoViewController = GameInfoViewController(game: game)
                        self.navigationController?.pushViewController(gameInfoViewController, animated: true)
                    }
                case .failure(let error):
                    print(error.rawValue)
                    // display error
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchController.searchBar.text
        
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines) {
            lastSearchText = searchText
            debouncedSearch!()
        }
        
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines) {
            lastSearchText = searchText
            debouncedSearch!()
        }
    }
}
