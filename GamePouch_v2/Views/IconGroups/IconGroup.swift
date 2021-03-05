//
//  IconGroup.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-29.
//

import UIKit

// Parent class for displaying game attribute info with an icon and label
// Relative positioning of icon and label varies in subclasses

class IconGroup: UIView {
    
    let label = UILabel()
    let iconImageView = UIImageView()
    
    init(labelText: String, icon: UIImage?) {
        super.init(frame: .zero)
        
        self.label.text = labelText
        self.iconImageView.image = icon
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [label, iconImageView].forEach { addSubview($0) }
        iconImageView.contentMode = .scaleAspectFit
    }
}
