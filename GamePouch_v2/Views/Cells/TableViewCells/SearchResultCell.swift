//
//  SearchResultCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-04.
//

import UIKit

protocol SearchResultCellDelegate: class {
    func didSelectSearchResult(_ searchResult: SearchResult)
}

class SearchResultCell: UITableViewCell {
    
    static let reuseID = "SearchResultCell"
    private let label = UILabel()
    
    private var searchResult: SearchResult?
    weak var delegate: SearchResultCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(searchResult: SearchResult) {
        self.searchResult = searchResult
        label.text = searchResult.name
    }
    
    @objc private func selectGame() -> Bool {
        if let delegate = delegate, let searchResult = searchResult {
            delegate.didSelectSearchResult(searchResult)
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Configuration
    
    private func configure() {
        self.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: FontSize.medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = Colors.purple
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.mediumPadding)
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
        
        let selectResult = UIAccessibilityCustomAction(name: "Select game", target: self, selector: #selector(selectGame))
        accessibilityCustomActions = [selectResult]
    }
}
