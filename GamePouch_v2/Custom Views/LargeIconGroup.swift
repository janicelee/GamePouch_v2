//
//  LargeIconGroup.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-13.
//

import UIKit

class LargeIconGroup: UIView {
    
    let label = UILabel()
    let iconImageView = UIImageView()
    
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
        configureLabel()
        configureImageView()
    }

    private func configureLabel() {
        addSubview(label)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        label.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
    }
    
    private func configureImageView() {
        addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit

        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(2)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(label).offset(-1)
            make.width.height.equalTo(16)
        }
    }
}
