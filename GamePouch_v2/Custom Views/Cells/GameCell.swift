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
    let ratingColumnView = UIView()
    let rankColumnView = UIView()
    let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
    let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)
    
    let primaryRowView = UIView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 16)
    
    let secondaryRowView = UIView()
    let playersColumnView = UIView()
    let timeColumnView = UIView()
    let difficultyColumnView = UIView()
    let ageColumnView = UIView()
    
    let playersIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.time)
    let difficultyIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.age)
    
    let outerEdgePadding: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureGameImageView()
        configureLargeIconGroup()
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
    
    private func configureLargeIconGroup() {
        gameImageView.addSubview(largeIconView)
        
        [ratingIconGroup, rankIconGroup].forEach { largeIconView.addSubview($0) }
        
        largeIconView.layer.cornerRadius = 6
        largeIconView.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        
        largeIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview().offset(8)
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(ratingIconGroup.snp.centerY)
        }
    }
    
    private func configurePrimaryRowView() {
        addSubview(primaryRowView)
        primaryRowView.addSubview(titleLabel)
        
        primaryRowView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
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
        
        playersIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(playersIconGroup.iconImageView.snp.trailing).offset(3).priority(999)
        }
        
        playersIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-1).priority(999)
        }

        timeIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playersIconGroup.snp.trailing).offset(14)
        }
        
        timeIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(timeIconGroup.iconImageView.snp.trailing).offset(2).priority(999)
        }

        difficultyIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(timeIconGroup.snp.trailing).offset(14)
        }
        
        difficultyIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(difficultyIconGroup.iconImageView.snp.trailing).offset(4).priority(999)
        }

        ageIconGroup.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(difficultyIconGroup.snp.trailing).offset(14)
        }
        
        secondaryRowView.updateConstraints()
    }
    
    func set(game: Game) {
        titleLabel.text = game.name
        ratingIconGroup.label.text = game.rating
        //rankIconGroup.label.text = getRankText(rank: game.rank)
        getRankText(rank: game.rank)
        playersIconGroup.label.text = game.minPlayers != nil && game.maxPlayers != nil && isValidDisplayText(game.minPlayers!) && isValidDisplayText(game.maxPlayers!) ? "\(game.minPlayers!)-\(game.maxPlayers!)" : "N/A"
        timeIconGroup.label.text = game.minPlayTime != nil && game.maxPlayTime != nil && isValidDisplayText(game.minPlayTime!) && isValidDisplayText(game.maxPlayTime!) ? "\(game.minPlayTime!)-\(game.maxPlayTime!) min" : "N/A"
        difficultyIconGroup.label.text = game.weight != nil && isValidDisplayText(game.weight!) ? "\(game.weight!)/5" : "N/A"
        ageIconGroup.label.text = game.minAge != nil && isValidDisplayText(game.minAge!) ? "\(game.minAge!)+" : "N/A"
        
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
    }
    
    private func isValidDisplayText(_ label: String) -> Bool {
        return !label.isEmpty && label != "0" && label != "0.0" && label != "Not Ranked"
    }
    
    private func getRankText(rank: String?) {
        guard let rank = rank, isValidDisplayText(rank) else {
            rankIconGroup.label.text = "N/A"
            return
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        if let rankInt = Int(rank) {
            let rankNSNumber = NSNumber(value: rankInt)
            guard var result = formatter.string(from: rankNSNumber) else {
                rankIconGroup.label.text = "N/A"
                return
            }
            result = result.replacingOccurrences(of: ",", with: "")
            
            let font: UIFont? = UIFont.systemFont(ofSize: 15, weight: .bold)
            let fontSuper: UIFont? = UIFont.systemFont(ofSize: 10, weight: .bold)
            let attString: NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
            let location = result.count - 2
            
            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location: location, length:2))
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = "N/A"
        }
    }
}
