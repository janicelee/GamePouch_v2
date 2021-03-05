//
//  VerticalLargeIconGroup.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-19.
//

import UIKit

// Icon group used on game info screen
// Icon placed above label

class GameInfoIconGroup: IconGroup {
    
    private let width: CGFloat = 22
    
    override func configure() {
        super.configure()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.small, weight: .bold)
        label.textColor = .secondaryLabel
        
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(width)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(Layout.smallPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
