//
//  PrimaryIconGroupView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-13.
//

import UIKit

class PrimaryIconGroupView: IconGroupView {
    
    private let width: CGFloat = 16
    private let horizontalOffset: CGFloat = 2
    private let verticalOffset: CGFloat = -1
    
    override func configure() {
        super.configure()
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.medium, weight: .bold)
        
        label.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(horizontalOffset)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(label).offset(verticalOffset)
            make.width.height.equalTo(width)
        }
    }
}
