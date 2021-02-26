//
//  SearchViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-02.
//

import UIKit
import CoreData

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
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = resultsTableController.tableView.indexPathForSelectedRow {
            resultsTableController.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func configure() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        resultsTableController = SearchResultsTableController()
        resultsTableController.delegate = self
        
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
        recentSearchTableController.delegate = self
        
        recentSearchTableController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func getSearchResults(for text: String) {
        NetworkManager.shared.search(for: text) { [weak self] result in
            guard let self = self else { return }
            
            if text == self.lastSearchText {
                switch result {
                case .success(let searchResults):
                    self.resultsTableController.searchResults = searchResults
                case .failure(let error):
                    self.presentErrorAlertOnMainThread(message: InternalError.generic.rawValue)
                    print("Failed to get search results for text: \(text), error: \(error.rawValue)")
                }
            }
        }
    }
    
    private func loadGameInfoView(for searchResult: SearchResult) {
        guard let id = searchResult.id, let name = searchResult.name else {
            return // TODO: display error
        }
        PersistenceManager.saveSearch(id: id, name: name)
        NetworkManager.shared.getGameInfo(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let game):
                DispatchQueue.main.async {
                    let gameInfoViewController = GameInfoViewController(game: game)
                    self.navigationController?.pushViewController(gameInfoViewController, animated: true)
                }
            case .failure(let error):
                self.presentErrorAlertOnMainThread(message: InternalError.generic.rawValue)
                print("Failed to get data for game id: \(id), error: \(error.rawValue)")
            }
        }
    }
    
    private func handleSearchText(_ searchText: String?) {
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines) {
            lastSearchText = searchText
            debouncedSearch!()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        handleSearchText(searchBar.text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        handleSearchText(searchController.searchBar.text)
    }
}

// MARK: - RecentSearchTableControllerDelegate

extension SearchViewController: RecentSearchTableControllerDelegate {
    func didSelectRecentSearch(result: SearchResult) {
        loadGameInfoView(for: result)
    }
}

// MARK: - SearchResultsTableControllerDelegate

extension SearchViewController: SearchResultsTableControllerDelegate {
    func didSelectSearchResult(result: SearchResult) {
        loadGameInfoView(for: result)
    }
}

