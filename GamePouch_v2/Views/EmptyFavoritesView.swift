//
//  EmptyFavoritesView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-24.
//

import UIKit

class EmptyFavoritesView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = TitleLabel(textAlignment: .center, fontSize: FontSize.xLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        configureImageView()
        configureTitleLabel()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.image = Images.filledHeart
        imageView.contentMode = .scaleAspectFit
        
        let width: CGFloat = 20
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Layout.largePadding)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(width)
        }
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "Browse or search games to add to your favorites."
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryLabel
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Layout.xLargePadding)
            make.leading.trailing.bottom.equalToSuperview().inset(Layout.largePadding)
        }
    }
}
