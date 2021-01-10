//
//  SearchResultCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-04.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    static let reuseID = "SearchResultCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Layout.smallPadding)
            make.leading.equalToSuperview().offset(Layout.mediumPadding)
            make.trailing.equalToSuperview().offset(-Layout.mediumPadding)
            make.bottom.equalToSuperview().offset(-Layout.smallPadding)
        }
    }
    
    func setLabel(to title: String) {
        label.text = title
    }
}