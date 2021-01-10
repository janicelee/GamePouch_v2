//
//  RecentSearchController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-07.
//

import UIKit
import CoreData

protocol RecentSearchTableControllerDelegate: class {
    func didSelectRecentSearch(id: String?, name: String?)
}

class RecentSearchTableController: UITableViewController {
    
    weak var delegate: RecentSearchTableControllerDelegate?
    var recentSearches: [NSManagedObject] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Search")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
    
        do {
            recentSearches = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        cell.setLabel(to: recentSearch.value(forKeyPath: "name") as? String ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Recent"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.smallPadding)
            make.leading.equalToSuperview().offset(Layout.mediumPadding)
            make.trailing.equalToSuperview().offset(-Layout.mediumPadding)
            make.bottom.equalToSuperview().offset(-Layout.smallPadding)
        }
        return view
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recentSearch = recentSearches[indexPath.row]
        let id = recentSearch.value(forKeyPath: "id") as? String ?? nil
        let name = recentSearch.value(forKeyPath: "name") as? String ?? nil
        
        delegate?.didSelectRecentSearch(id: id, name: name)
    }
}
