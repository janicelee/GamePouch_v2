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
    let ratingColumn = UIView()
    let ratingIconGroup = LargeIconGroup(labelText: "8.8", iconImage: Images.rating)
    let rankColumn = UIView()
    let rankIconGroup = LargeIconGroup(labelText: "32", iconImage: Images.rank)
    
    let secondaryRowView = UIView()
    let playersColumn = UIView()
    let timeColumn = UIView()
    let difficultyColumn = UIView()
    let ageColumn = UIView()
    
    let playersIconGroup = SmallIconGroup(labelText: "1-5", iconImage: Images.players)
    let timeIconGroup = SmallIconGroup(labelText: "80 min", iconImage: Images.time)
    let difficultyIconGroup = SmallIconGroup(labelText: "2.4/5", iconImage: Images.difficulty)
    let ageIconGroup = SmallIconGroup(labelText: "10+", iconImage: Images.age)
    
    let padding: CGFloat = 14
    
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
            make.leading.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(200)
        }
    }
    
    private func configurePrimaryRowView() {
        addSubview(primaryRowView)
        [titleColumn, ratingColumn, rankColumn].forEach { primaryRowView.addSubview($0) }
        titleColumn.addSubview(titleLabel)
        ratingColumn.addSubview(ratingIconGroup)
        rankColumn.addSubview(rankIconGroup)
        
        primaryRowView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(28)
        }
        
        titleColumn.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        
        ratingColumn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(titleColumn.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.2)
        }

        rankColumn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(ratingColumn.snp.trailing)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configureSecondaryRowView() {
        addSubview(secondaryRowView)
        
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach {
            secondaryRowView.addSubview($0)
        }

//        playersColumn.addSubview(playersIconGroup)
//        timeColumn.addSubview(timeIconGroup)
//        difficultyColumn.addSubview(difficultyIconGroup)
//        ageColumn.addSubview(ageIconGroup)
    
//        playersColumn.backgroundColor = .systemIndigo
//        timeColumn.backgroundColor = .systemPurple
//        difficultyColumn.backgroundColor = .systemRed
//        ageColumn.backgroundColor = .systemOrange
//
//        secondaryRowView.backgroundColor = .systemGray
//        playersIconGroup.backgroundColor = .systemPink
//        timeIconGroup.backgroundColor = .systemBlue
//        difficultyIconGroup.backgroundColor = .systemGreen
//        ageIconGroup.backgroundColor = .systemYellow
        
        secondaryRowView.snp.makeConstraints { make in
            make.top.equalTo(primaryRowView.snp.bottom)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(20)
        }
        
        playersIconGroup.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
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
        
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
    }
}
