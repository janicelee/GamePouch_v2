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
        
        let verticalPadding: CGFloat = 6
        let edgePadding: CGFloat = 10
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.equalToSuperview().offset(edgePadding)
            make.trailing.equalToSuperview().offset(-edgePadding)
            make.bottom.equalToSuperview().offset(-verticalPadding)
        }
    }
    
    func setLabel(to title: String) {
        label.text = title
    }
}
