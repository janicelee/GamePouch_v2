//
//  VerticalLargeIconGroup.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-19.
//

import UIKit

class VerticalLargeIconGroup: UIView {
    
    let iconImageView = UIImageView()
    let label = UILabel()
    
    required init(labelText: String, iconImage: UIImage?) {
        label.text = labelText
        iconImageView.image = iconImage
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureImageView()
        configureLabel()
    }
    
    private func configureImageView() {
        addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit
        
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(22)
        }
    }
    
    private func configureLabel() {
        addSubview(label)
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.textColor = .secondaryLabel
        
        label.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
