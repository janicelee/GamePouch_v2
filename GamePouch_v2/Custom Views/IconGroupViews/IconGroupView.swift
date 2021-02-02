//
//  IconGroupView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-29.
//

import UIKit

class IconGroupView: UIView {
    
    let label = UILabel()
    let iconImageView = UIImageView()
    
    required init(label: String, icon: UIImage?) {
        self.label.text = label
        self.iconImageView.image = icon
        
        super.init(frame: .zero)
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
