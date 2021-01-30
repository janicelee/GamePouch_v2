//
//  SecondaryIconGroupView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-15.
//

import UIKit

class SecondaryIconGroupView: IconGroupView {
    
    override func configure() {
        super.configure()
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .secondaryLabel
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).priority(998)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().priority(998)
            make.width.height.equalTo(16)
        }
    }
}
