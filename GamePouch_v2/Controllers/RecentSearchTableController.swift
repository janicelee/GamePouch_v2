//
//  RecentSearchController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-07.
//

import UIKit

class RecentSearchTableController: UITableViewController {
    
    var recentSearches = ["Mansions of Madness", "Pandemic", "Gloomhaven"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseID, for: indexPath) as! SearchResultCell
        let recentSearch = recentSearches[indexPath.row]
        cell.setLabel(to: recentSearch)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Recent Searches"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.smallPadding)
            make.leading.equalToSuperview().offset(Layout.mediumPadding)
            make.trailing.equalToSuperview().offset(-Layout.mediumPadding)
            make.bottom.equalToSuperview().offset(-Layout.smallPadding)
        }
        return view
    }
}
