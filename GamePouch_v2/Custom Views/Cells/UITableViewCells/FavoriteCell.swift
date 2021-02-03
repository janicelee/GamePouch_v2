//
//  FavoriteCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-13.
//

import UIKit
import CoreData

class FavoriteCell: UITableViewCell {
    
    static let reuseID = "FavoriteCell"
    
    let gameImageView = GameImageView(frame: .zero)
    let containerView = UIView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: FontSize.medium)
    let ratingIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.rating)
    let rankIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.rank)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [gameImageView, containerView].forEach { addSubview($0) }
        [titleLabel, ratingIconGroup, rankIconGroup].forEach { containerView.addSubview($0) }

        gameImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.smallPadding).priority(999)
            make.leading.equalToSuperview().offset(Layout.largePadding)
            make.width.equalTo(60)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView)
            make.leading.equalTo(gameImageView.snp.trailing).offset(Layout.smallPadding)
            make.trailing.equalToSuperview().inset(Layout.largePadding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        ratingIconGroup.label.font = UIFont.systemFont(ofSize: FontSize.medium, weight: .bold)
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.smallPadding)
            make.leading.equalToSuperview().offset(2)
            make.bottom.equalToSuperview()
        }
        
        ratingIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.iconImageView.snp.trailing).offset(2)
        }
        
        ratingIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-3).priority(999)
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.top.equalTo(ratingIconGroup)
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(Layout.mediumPadding)
        }
        
        rankIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(rankIconGroup.iconImageView.snp.trailing).offset(2)
        }
        
        rankIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-2).priority(999)
        }
    }
    
    func set(game: Game) {
        titleLabel.text = game.getTitle()
        ratingIconGroup.label.text = game.getRating()

        if let rank = game.getRank() {
            rankIconGroup.label.attributedText = rank.toOrdinalString(fontSize: FontSize.medium, superscriptFontSize: FontSize.superscript, weight: .bold)
        } else {
            rankIconGroup.label.text = "N/A"
        }
        
        if let thumbnailURL = game.thumbnailURL {
            gameImageView.setImage(from: thumbnailURL)
        }
    }
    
    func clearImage() {
        gameImageView.image = Images.placeholder
    }
}
