//
//  VerticalLargeIconGroup.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-19.
//

import UIKit

class GameInfoIconGroupView: IconGroupView {
    
    override func configure() {
        super.configure()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .secondaryLabel
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(22)
        }
    }
}
