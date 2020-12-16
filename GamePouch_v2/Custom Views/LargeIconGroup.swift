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
        
        self.snp.makeConstraints { make in
            make.width.equalTo(46)
            make.height.equalTo(20)
        }
    }

    private func configureLabel() {
        addSubview(label)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        
        label.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
        }
    }
    
    private func configureImageView() {
        addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit

        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing)
            make.bottom.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }
}
