//
//  SecondaryIconGroupView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-15.
//

import UIKit

class SecondaryAttributesIconGroup: IconGroup {
    
    private let width: CGFloat = 16
    
    override func configure() {
        super.configure()
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.small, weight: .bold)
        label.textColor = .secondaryLabel
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().priority(998)
            make.width.height.equalTo(width).priority(998)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).priority(998)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}
