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
    let infoContainerView = UIStackView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 16)
    let statsView = UIView()
    
    let firstColumn = UIStackView()
    let playersIconGroup = SecondaryIconGroupView(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = SecondaryIconGroupView(labelText: "N/A", iconImage: Images.time)
    
    let secondColumn = UIStackView()
    let difficultyIconGroup = SecondaryIconGroupView(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = SecondaryIconGroupView(labelText: "N/A", iconImage: Images.age)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [gameImageView, infoContainerView].forEach { addSubview($0) }
        [titleLabel, statsView].forEach { infoContainerView.addArrangedSubview($0) }
        [firstColumn, secondColumn].forEach { statsView.addSubview($0) }
        [playersIconGroup, difficultyIconGroup].forEach { firstColumn.addArrangedSubview($0) }
        [timeIconGroup, ageIconGroup].forEach { secondColumn.addArrangedSubview($0) }
        
        infoContainerView.axis = .vertical
        infoContainerView.spacing = Layout.smallPadding
        
        firstColumn.axis = .vertical
        firstColumn.spacing = Layout.smallPadding
        
        secondColumn.axis = .vertical
        secondColumn.spacing = Layout.smallPadding
        
        gameImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.smallPadding).priority(999)
            make.leading.equalToSuperview().offset(Layout.largePadding)
            make.width.equalTo(74)
        }
        
        infoContainerView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView)
            make.leading.equalTo(gameImageView.snp.trailing).offset(Layout.smallPadding)
            make.trailing.equalToSuperview().inset(Layout.largePadding)
        }
        
        firstColumn.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        secondColumn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(firstColumn.snp.trailing).offset(Layout.largePadding + 8)
        }
    }
    
    func set(game: Game) {
        titleLabel.text = game.getTitle()
//        ratingIconGroup.label.text = game.getRating()
        playersIconGroup.label.text = game.getNumPlayers()
        timeIconGroup.label.text = game.getPlayTime()
        difficultyIconGroup.label.text = game.getDifficulty()
        ageIconGroup.label.text = game.getMinAge()
        
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
    
    func resetImage() {
        gameImageView.image = Images.placeholder
    }
}
