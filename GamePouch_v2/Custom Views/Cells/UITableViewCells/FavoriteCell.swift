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
    
    let containerView = UIStackView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: FontSize.medium)
    let gameAttributesView = UIView()
    
    let leftColumn = UIStackView()
    let playersIconGroup = SecondaryIconGroupView(label: "N/A", icon: Images.players)
    let timeIconGroup = SecondaryIconGroupView(label: "N/A", icon: Images.time)
    
    let rightColumn = UIStackView()
    let difficultyIconGroup = SecondaryIconGroupView(label: "N/A", icon: Images.difficulty)
    let ageIconGroup = SecondaryIconGroupView(label: "N/A", icon: Images.age)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [gameImageView, containerView].forEach { addSubview($0) }
        [titleLabel, gameAttributesView].forEach { containerView.addArrangedSubview($0) }
        [leftColumn, rightColumn].forEach { gameAttributesView.addSubview($0) }
        [playersIconGroup, difficultyIconGroup].forEach { leftColumn.addArrangedSubview($0) }
        [timeIconGroup, ageIconGroup].forEach { rightColumn.addArrangedSubview($0) }
        
        containerView.axis = .vertical
        containerView.spacing = Layout.smallPadding
        
        leftColumn.axis = .vertical
        leftColumn.spacing = Layout.smallPadding
        
        rightColumn.axis = .vertical
        rightColumn.spacing = Layout.smallPadding
        
        gameImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.smallPadding).priority(999)
            make.leading.equalToSuperview().offset(Layout.largePadding)
            make.width.equalTo(74)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView)
            make.leading.equalTo(gameImageView.snp.trailing).offset(Layout.smallPadding)
            make.trailing.equalToSuperview().inset(Layout.largePadding)
        }
        
        leftColumn.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        rightColumn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(leftColumn.snp.trailing).offset(Layout.largePadding + 8)
        }
    }
    
    func set(game: Game) {
        titleLabel.text = game.getTitle()
//        ratingIconGroup.label.text = game.getRating()
        playersIconGroup.label.text = game.getNumPlayers()
        timeIconGroup.label.text = game.getPlayTime()
        difficultyIconGroup.label.text = game.getDifficultyDisplayText()
        ageIconGroup.label.text = game.getMinAgeDisplayText()
        
//        let rank = game.getRank()
//        if let attString = rank.attributedString {
//            rankIconGroup.label.attributedText = attString
//        } else {
//            rankIconGroup.label.text = rank.text
//        }
        
        if let thumbnailURL = game.thumbnailURL {
            gameImageView.setImage(from: thumbnailURL)
        }
    }
    
    func clearImage() {
        gameImageView.image = Images.placeholder
    }
}
