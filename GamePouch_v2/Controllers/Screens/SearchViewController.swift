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
    private var resultsTableViewController: SearchResultsTableViewController!
    private var recentsTableViewController: RecentSearchTableViewController!
    
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
        
        if let selectedIndexPath = resultsTableViewController.tableView.indexPathForSelectedRow {
            resultsTableViewController.tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    private func getSearchResults(for text: String) {
        BoardGameGeekClient.shared.search(for: text) { [weak self] result in
            guard let self = self else { return }
            
            if text == self.lastSearchText {
                switch result {
                case .success(let searchResults):
                    self.resultsTableViewController.setSearchResults(searchResults)
                case .failure(let error):
                    self.presentErrorAlertOnMainThread(message: InternalError.generic.rawValue)
                    print("Failed to get search results for text: \(text), error: \(error.rawValue)")
                }
            }
        }
    }
    
    private func handleSearchText(_ searchText: String?) {
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines) {
            lastSearchText = searchText
            debouncedSearch!()
        }
    }
    
    private func loadGameInfoView(for searchResult: SearchResult) {
        guard let id = searchResult.id, let name = searchResult.name else {
            self.presentErrorAlertOnMainThread(message: InternalError.generic.rawValue)
            return
        }
        
        CoreDataClient.shared.saveSearch(id: id, name: name)
        BoardGameGeekClient.shared.getGame(id: id) { [weak self] result in
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
    
    // MARK: - Configuration
    
    private func configure() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        resultsTableViewController = SearchResultsTableViewController()
        resultsTableViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a game"
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        recentsTableViewController = RecentSearchTableViewController()
        addChild(recentsTableViewController)
        view.addSubview(recentsTableViewController.view)
        recentsTableViewController.didMove(toParent: self)
        recentsTableViewController.delegate = self
        
        recentsTableViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
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

extension SearchViewController: RecentSearchTableViewControllerDelegate {
    
    func didSelectRecentSearch(searchResult: SearchResult) {
        loadGameInfoView(for: searchResult)
    }
}

// MARK: - SearchResultsTableControllerDelegate

extension SearchViewController: SearchResultsTableViewControllerDelegate {
    
    func didSelectSearchResult(searchResult: SearchResult) {
        loadGameInfoView(for: searchResult)
    }
}

