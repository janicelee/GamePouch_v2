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
    let primaryRowView = UIView()
    let titleColumn = UIView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 16)
    let largeIconGroupColumn = UIView()
    let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
    let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)
    
    let secondaryRowView = UIView()
    let playersColumn = UIView()
    let timeColumn = UIView()
    let difficultyColumn = UIView()
    let ageColumn = UIView()
    
    let playersIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.time)
    let difficultyIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.age)
    
    let outerEdgePadding: CGFloat = 16
    let titleColumnProportion = 0.7
    var largeIconGroupPorportion: Double {
        return (1 - titleColumnProportion)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureGameImageView()
        configurePrimaryRowView()
        configureSecondaryRowView()
    }
    
    private func configureGameImageView() {
        addSubview(gameImageView)
        
        gameImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(outerEdgePadding)
            make.height.equalTo(200)
        }
    }
    
    private func configurePrimaryRowView() {
        addSubview(primaryRowView)
        [titleColumn, largeIconGroupColumn].forEach { primaryRowView.addSubview($0) }
        titleColumn.addSubview(titleLabel)
        [ratingIconGroup, rankIconGroup].forEach { largeIconGroupColumn.addSubview($0) }
        
        primaryRowView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(28)
        }
        
        titleColumn.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(titleColumnProportion)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        
        largeIconGroupColumn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(titleColumn.snp.trailing)
            make.width.equalToSuperview().multipliedBy(largeIconGroupPorportion)
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(2)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    private func configureSecondaryRowView() {
        addSubview(secondaryRowView)
        
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach {
            secondaryRowView.addSubview($0)
        }
        
        secondaryRowView.snp.makeConstraints { make in
            make.top.equalTo(primaryRowView.snp.bottom)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(20)
        }
        
        playersIconGroup.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
        }

        timeIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playersIconGroup.snp.trailing).offset(14)
        }

        difficultyIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(timeIconGroup.snp.trailing).offset(14)
        }

        ageIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(difficultyIconGroup.snp.trailing).offset(14)
        }
    }
    
    func set(game: Game) {
        titleLabel.text = game.name
        ratingIconGroup.label.text = game.rating
        rankIconGroup.label.text = game.rank != nil && game.rank!.isValidDisplayText() ? game.rank : "N/A"
        playersIconGroup.label.text = game.minPlayers != nil && game.maxPlayers != nil && game.minPlayers!.isValidDisplayText() && game.maxPlayers!.isValidDisplayText() ? "\(game.minPlayers!)-\(game.maxPlayers!)" : "N/A"
        timeIconGroup.label.text = game.minPlayTime != nil && game.maxPlayTime != nil && game.minPlayTime!.isValidDisplayText() && game.maxPlayTime!.isValidDisplayText() ? "\(game.minPlayTime!)-\(game.maxPlayTime!) min" : "N/A"
        difficultyIconGroup.label.text = game.weight != nil && game.weight!.isValidDisplayText() ? "\(game.weight!)/5" : "N/A"
        ageIconGroup.label.text = game.minAge != nil && game.minAge!.isValidDisplayText() ? "\(game.minAge!)+" : "N/A"
        
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
    }
}
