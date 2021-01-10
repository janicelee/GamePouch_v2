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
        NetworkManager.shared.search(for: text) { [weak self] result in
            guard let self = self else { return }
            
            if text == self.lastSearchText {
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
    
    private func save(searchResult: SearchResult) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Search", in: managedContext)!
        let search = NSManagedObject(entity: entity, insertInto: managedContext)
        
        search.setValue(searchResult.id, forKey: "id")
        search.setValue(searchResult.name, forKey: "name")
        search.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Search")
            let count = try managedContext.count(for: fetchRequest)
            
            if count > 5 {
                let sort = NSSortDescriptor(key: "date", ascending: true)
                fetchRequest.sortDescriptors = [sort]
                fetchRequest.fetchLimit = 1
                
                let oldestSearch = try managedContext.fetch(fetchRequest)
                if oldestSearch.count == 1 {
                    managedContext.delete(oldestSearch[0])
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = resultsTableController.searchResults[indexPath.row]
        save(searchResult: searchResult)
        
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
