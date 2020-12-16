//
//  GameImageView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-11.
//

import UIKit

class GameImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = Images.placeholder
        contentMode = .scaleAspectFill
    }
}
