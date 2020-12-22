//
//  TagCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-20.
//

import UIKit
import SnapKit

class TagCell: UICollectionViewCell {
    static let reuseID = "TagCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(to title: String) {
        label.text = title
    }
    
    private func configure() {
        addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        label.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
