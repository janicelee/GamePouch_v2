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
    let attributesContainerView = UIView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: FontSize.medium)
    let ratingIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.rating)
    let rankIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.rank)
    
    private let cellWidth: CGFloat = 60
    private let attributeFontSize = FontSize.medium
    private let attributeFontWeight = UIFont.Weight.semibold
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [gameImageView, attributesContainerView].forEach { addSubview($0) }
        [titleLabel, ratingIconGroup, rankIconGroup].forEach { attributesContainerView.addSubview($0) }

        gameImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.mediumPadding)
            make.leading.equalToSuperview().offset(Layout.xLargePadding)
            make.width.equalTo(cellWidth)
        }
        
        attributesContainerView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView)
            make.leading.equalTo(gameImageView.snp.trailing).offset(Layout.mediumPadding)
            make.trailing.equalToSuperview().inset(Layout.xLargePadding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        configureRatingIconGroup()
        configureRankIconGroup()
    }
    
    private func configureRatingIconGroup() {
        ratingIconGroup.label.font = UIFont.systemFont(ofSize: attributeFontSize, weight: attributeFontWeight)
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Layout.mediumPadding)
            make.leading.equalToSuperview().offset(Layout.xsPadding)
            make.bottom.equalToSuperview()
        }
        
        ratingIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-3).priority(999)
        }
        
        ratingIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.iconImageView.snp.trailing).offset(Layout.xsPadding)
        }
    }
    
    private func configureRankIconGroup() {
        rankIconGroup.snp.makeConstraints { make in
            make.top.equalTo(ratingIconGroup)
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(Layout.largePadding)
        }
        
        rankIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-2).priority(999)
        }
        
        rankIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(rankIconGroup.iconImageView.snp.trailing).offset(Layout.xsPadding)
        }
    }
    
    func set(game: Game) {
        titleLabel.text = game.getTitle()
        ratingIconGroup.label.text = game.getRating()

        if let rank = game.getRank(),
           let attString = rank.toOrdinalString(fontSize: attributeFontSize, superscriptFontSize: FontSize.superscript, weight: attributeFontWeight) {
            rankIconGroup.label.attributedText = attString
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
