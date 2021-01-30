//
//  PrimaryIconGroupView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-13.
//

import UIKit

class PrimaryIconGroupView: IconGroupView {
    
    override func configure() {
        super.configure()
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        label.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(2)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(label).offset(-1)
            make.width.height.equalTo(16)
        }
    }
}
