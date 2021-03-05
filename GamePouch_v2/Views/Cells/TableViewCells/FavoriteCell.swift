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
    
    private let gameImageView = GameImageView(frame: .zero)
    private let attributesContainerView = UIView()
    private let titleLabel = TitleLabel(textAlignment: .left, fontSize: FontSize.medium)
    private let ratingIconGroup = SecondaryAttributesIconGroup(labelText: "N/A", icon: Images.rating)
    private let rankIconGroup = SecondaryAttributesIconGroup(labelText: "N/A", icon: Images.rank)
    
    private let gameImageViewWidth: CGFloat = 60
    private let attributeFontSize = FontSize.small
    private let attributeFontWeight = UIFont.Weight.semibold
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(game: Game) {
        titleLabel.text = game.getTitle()
        titleLabel.accessibilityLabel = "Title: \(formatGameLabelToAccessibleText(game.getTitle()))"
        
        ratingIconGroup.label.text = game.getRating()
        ratingIconGroup.label.accessibilityLabel = "Rating: \(formatGameLabelToAccessibleText(game.getRating()))"

        if let rank = game.getRank(),
           let attString = rank.toOrdinalString(fontSize: attributeFontSize, superscriptFontSize: FontSize.superscript, weight: attributeFontWeight) {
            rankIconGroup.label.attributedText = attString
            rankIconGroup.label.accessibilityLabel = "Rank: \(String(rank))"
        } else {
            rankIconGroup.label.text = "N/A"
            rankIconGroup.label.accessibilityLabel = "Rank: Not Available"
        }
        
        if let thumbnailURL = game.thumbnailURL {
            gameImageView.setImage(from: thumbnailURL)
        }
    }
    
    func clearImage() {
        gameImageView.image = Images.placeholder
    }
    
    // MARK: - Configuration
    
    private func configure() {
        [gameImageView, attributesContainerView].forEach { addSubview($0) }
        [titleLabel, ratingIconGroup, rankIconGroup].forEach { attributesContainerView.addSubview($0) }
        accessibilityElements = [titleLabel, ratingIconGroup.label, rankIconGroup.label]
        
        gameImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.mediumPadding).priority(999)
            make.leading.equalToSuperview().offset(Layout.xLargePadding)
            make.width.equalTo(gameImageViewWidth)
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
            make.bottom.equalToSuperview().offset(-2).priority(999)
        }
        
        ratingIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.iconImageView.snp.trailing).offset(Layout.xsPadding)
        }
    }
    
    private func configureRankIconGroup() {
        rankIconGroup.label.font = UIFont.systemFont(ofSize: attributeFontSize, weight: attributeFontWeight)
        
        rankIconGroup.snp.makeConstraints { make in
            make.top.equalTo(ratingIconGroup)
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(Layout.largePadding)
        }
        
        rankIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-1).priority(999)
        }
        
        rankIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(rankIconGroup.iconImageView.snp.trailing).offset(Layout.xsPadding)
        }
    }
}
