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
    static let verticalPadding: CGFloat = 4
    static let horizontalPadding: CGFloat = 12
    static let font = UIFont.systemFont(ofSize: 15)
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(label)
        
        label.font = TagCell.font
        label.textAlignment = .center
        
        layer.cornerRadius = 14
        layer.borderWidth = 2
        layer.borderColor = UIColor.secondaryLabel.cgColor
    
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(TagCell.verticalPadding)
            make.bottom.equalToSuperview().offset(-TagCell.verticalPadding)
            make.leading.equalToSuperview().offset(TagCell.horizontalPadding)
            make.trailing.equalToSuperview().offset(-TagCell.horizontalPadding)
        }
    }
    
    func setLabel(to title: String) {
        label.text = title
    }
}
