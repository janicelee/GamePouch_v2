//
//  GameCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-03.
//

import UIKit
import SnapKit

class GameCell: UITableViewCell {
    
    static let reuseID = "GameCell"
    
    let gameImageView = GameImageView(frame: .zero)
    let largeIconView = UIView()
    let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
    let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)
    
    let primaryRowView = UIView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 16)
    let favoriteButton = FavoriteButton()
    
    let secondaryRowView = UIView()
    let playersIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.time)
    let difficultyIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.age)
    
    private let gameImageViewHeight = 210
    private let primaryRowViewHeight = 28
    private let favoriteButtonWidth = 34
    private let secondaryRowViewHeight = 20
    
    private var game: Game?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.isUserInteractionEnabled = false
        configureGameImageView()
        configureLargeIconView()
        configurePrimaryRowView()
        configureSecondaryRowView()
    }
    
    private func configureGameImageView() {
        addSubview(gameImageView)
        
        gameImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Layout.largePadding)
            make.height.equalTo(gameImageViewHeight)
        }
    }
    
    private func configureLargeIconView() {
        gameImageView.addSubview(largeIconView)
        [ratingIconGroup, rankIconGroup].forEach { largeIconView.addSubview($0) }
        
        largeIconView.layer.cornerRadius = 6
        largeIconView.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        
        ratingIconGroup.label.textColor = .black
        rankIconGroup.label.textColor = .black
        
        largeIconView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().offset(8)
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(ratingIconGroup.snp.centerY)
        }
    }
    
    private func configurePrimaryRowView() {
        addSubview(primaryRowView)
        [titleLabel, favoriteButton].forEach { primaryRowView.addSubview($0) }
        
        favoriteButton.setImage(Images.emptyHeart, for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        
        primaryRowView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(primaryRowViewHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-4)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(favoriteButtonWidth)
        }
    }
    
    private func configureSecondaryRowView() {
        addSubview(secondaryRowView)
        
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach {
            secondaryRowView.addSubview($0)
        }
        
        secondaryRowView.snp.makeConstraints { make in
            make.top.equalTo(primaryRowView.snp.bottom).offset(2)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(secondaryRowViewHeight)
        }
        
        playersIconGroup.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
        }
        
        playersIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-1).priority(999)
        }
        
        playersIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(playersIconGroup.iconImageView.snp.trailing).offset(3).priority(999)
        }

        timeIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playersIconGroup.snp.trailing).offset(Layout.largePadding)
        }
        
        timeIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(timeIconGroup.iconImageView.snp.trailing).offset(2).priority(999)
        }

        difficultyIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(timeIconGroup.snp.trailing).offset(Layout.largePadding)
        }
        
        difficultyIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(difficultyIconGroup.iconImageView.snp.trailing).offset(4).priority(999)
        }

        ageIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(difficultyIconGroup.snp.trailing).offset(Layout.largePadding)
        }
        
        secondaryRowView.updateConstraints()
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        let isInFavorites = game!.isInFavorites()
    
        if isInFavorites {
            game!.setFavorite(to: false)
            favoriteButton.setImage(Images.emptyHeart, for: .normal)
        } else {
            game!.setFavorite(to: true)
            favoriteButton.setImage(Images.filledHeart, for: .normal)
        }
    }
    
    func set(game: Game) {
        self.game = game
        titleLabel.text = game.getTitle()
        ratingIconGroup.label.text = game.getRating()
        playersIconGroup.label.text = game.getNumPlayers()
        timeIconGroup.label.text = game.getPlayTime()
        difficultyIconGroup.label.text = game.getDifficulty()
        ageIconGroup.label.text = game.getMinAge()
        
        let rank = game.getRank()
        if let attString = rank.attributedString {
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = rank.text
        }
        
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
        
        let image = self.game!.isInFavorites() ? Images.filledHeart : Images.emptyHeart
        favoriteButton.setImage(image, for: .normal)
    }
    
    func resetImage() {
        gameImageView.image = Images.placeholder
    }
}
