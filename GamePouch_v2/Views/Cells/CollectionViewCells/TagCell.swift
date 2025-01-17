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
    static let font = UIFont.systemFont(ofSize: FontSize.small)
    static let horizontalPadding: CGFloat = 12
    static let verticalPadding: CGFloat = 4
    
    private let cornerRadius: CGFloat = 14
    private let borderWidth: CGFloat = 2
    
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
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.systemGray.cgColor
    
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(TagCell.verticalPadding)
            make.leading.trailing.equalToSuperview().inset(TagCell.horizontalPadding)
        }
    }
    
    func setLabel(to title: String, borderColor: UIColor) {
        label.text = title
        layer.borderColor = borderColor.cgColor
    }
}
