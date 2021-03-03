//
//  RecentSearchTableViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-07.
//

import UIKit
import CoreData

protocol RecentSearchTableViewControllerDelegate: class {
    func didSelectRecentSearch(searchResult: SearchResult)
}

class RecentSearchTableViewController: UITableViewController {
    
    private let headerHeight: CGFloat = 50
    
    private var recentSearches: [SearchResult] = [] {
        didSet { DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    weak var delegate: RecentSearchTableViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentSearches = CoreDataClient.shared.fetchRecentSearches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as! SearchResultCell
        let recentSearch = recentSearches[indexPath.row]
        cell.set(searchResult: recentSearch)
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentSearch = recentSearches[indexPath.row]
        delegate?.didSelectRecentSearch(searchResult: recentSearch)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerHeight))
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.large, weight: .bold)
        label.text = "Recent"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.mediumPadding)
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
        return view
    }
}

// MARK: - SearchResultCellDelegate

extension RecentSearchTableViewController: SearchResultCellDelegate {
    
    func didSelectSearchResult(_ searchResult: SearchResult) {
        delegate?.didSelectRecentSearch(searchResult: searchResult)
    }
}
