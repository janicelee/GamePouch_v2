//
//  CreditsView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-22.
//

import UIKit

class DetailedInfoView: UIView {
    
    let ratingIconGroup = SecondaryAttributesIconGroup(label: "Number of players", icon: Images.players)
    let timeIconGroup = SecondaryAttributesIconGroup(label: "Playtime", icon: Images.time)
    let difficultyIconGroup = SecondaryAttributesIconGroup(label: "Difficulty", icon: Images.difficulty)
    let ageIconGroup = SecondaryAttributesIconGroup(label: "Minimum Age", icon: Images.age)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        [ratingIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach {
            addSubview($0)
            $0.label.font = UIFont.systemFont(ofSize: FontSize.medium, weight: .medium)
            $0.snp.makeConstraints { make in make.leading.trailing.equalToSuperview() }
            
            let iconImageView = $0.iconImageView
            let horizontalPadding: CGFloat = 6
            
            iconImageView.snp.makeConstraints { make in make.width.height.equalTo(20).priority(999) }
            
            $0.label.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(horizontalPadding).priority(999)
            }
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        timeIconGroup.snp.makeConstraints { make in
            make.top.equalTo(ratingIconGroup.snp.bottom).offset(Layout.largePadding)
        }
        
        difficultyIconGroup.snp.makeConstraints { make in
            make.top.equalTo(timeIconGroup.snp.bottom).offset(Layout.largePadding)
        }
        
        ageIconGroup.snp.makeConstraints { make in
            make.top.equalTo(difficultyIconGroup.snp.bottom).offset(Layout.largePadding)
        }
    }
}
