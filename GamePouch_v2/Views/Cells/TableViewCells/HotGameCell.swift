//
//  HotGameCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-03.
//

import UIKit
import SnapKit

protocol HotGameCellDelegate: class {
    func didFailToUpdateFavorite(id: String, error: Error)
}

class HotGameCell: UITableViewCell {
    
    static let reuseID = "GameCell"
    
    let gameImageView = GameImageView(frame: .zero)
    let ratingAndRankView = UIView()
    let ratingIconGroup = MainAttributesIconGroup(label: "N/A", icon: Images.rating)
    let rankIconGroup = MainAttributesIconGroup(label: "N/A", icon: Images.rank)
    
    let titleContainerView = UIView()
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: FontSize.medium)
    let favoriteButton = FavoriteButton()
    
    let gameAttributesView = UIView()
    let playersIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.players)
    let timeIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.time)
    let difficultyIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.difficulty)
    let ageIconGroup = SecondaryAttributesIconGroup(label: "N/A", icon: Images.age)
    
    private let gameImageViewHeight = 210
    private let primaryRowViewHeight = 28
    private let favoriteButtonWidth = 32
    private let secondaryRowViewHeight = 20
    
    weak var delegate: HotGameCellDelegate?
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
        configureRatingandRankView()
        configureTitleContainerView()
        configureGameAttributesView()
    }
    
    private func configureGameImageView() {
        addSubview(gameImageView)
        
        gameImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Layout.xLargePadding)
            make.height.equalTo(gameImageViewHeight)
        }
    }
    
    private func configureRatingandRankView() {
        gameImageView.addSubview(ratingAndRankView)
        [ratingIconGroup, rankIconGroup].forEach { ratingAndRankView.addSubview($0) }
        
        ratingAndRankView.layer.cornerRadius = 6
        ratingAndRankView.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        
        ratingIconGroup.label.textColor = .black
        rankIconGroup.label.textColor = .black
        
        ratingAndRankView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Layout.largePadding)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Layout.smallPadding)
            make.leading.equalToSuperview().offset(Layout.mediumPadding)
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(Layout.mediumPadding)
            make.trailing.equalToSuperview().inset(Layout.mediumPadding)
            make.centerY.equalTo(ratingIconGroup.snp.centerY)
        }
    }
    
    private func configureTitleContainerView() {
        addSubview(titleContainerView)
        [titleLabel, favoriteButton].forEach { titleContainerView.addSubview($0) }
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
        
        titleContainerView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(Layout.smallPadding)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(primaryRowViewHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(Layout.smallPadding)
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(favoriteButtonWidth)
        }
    }
    
    private func configureGameAttributesView() {
        addSubview(gameAttributesView)
        
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach {
            gameAttributesView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
        }
        
        gameAttributesView.snp.makeConstraints { make in
            make.top.equalTo(titleContainerView.snp.bottom).offset(2)
            make.leading.trailing.equalTo(gameImageView)
            make.height.equalTo(secondaryRowViewHeight)
        }
        
        // Icons require slight offset tweaking for uniformity 
        
        playersIconGroup.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
        }
        
        playersIconGroup.iconImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-1).priority(999)
        }
        
        playersIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(playersIconGroup.iconImageView.snp.trailing).offset(3).priority(999)
        }

        timeIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(playersIconGroup.snp.trailing).offset(Layout.xLargePadding)
        }
        
        timeIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(timeIconGroup.iconImageView.snp.trailing).offset(2).priority(999)
        }

        difficultyIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(timeIconGroup.snp.trailing).offset(Layout.xLargePadding)
        }
        
        difficultyIconGroup.label.snp.makeConstraints { make in
            make.leading.equalTo(difficultyIconGroup.iconImageView.snp.trailing).offset(4).priority(999)
        }

        ageIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(difficultyIconGroup.snp.trailing).offset(Layout.xLargePadding)
        }
        
        gameAttributesView.updateConstraints()
    }
    
    func set(game: Game) {
        self.game = game
        titleLabel.text = game.getTitle()
        ratingIconGroup.label.text = game.getRating()
        playersIconGroup.label.text = game.getNumPlayers()
        timeIconGroup.label.text = game.getPlayTime()
        difficultyIconGroup.label.text = game.getDifficultyDisplayText()
        ageIconGroup.label.text = game.getMinAgeDisplayText()
        
        if let rank = game.getRank(),
           let attString = rank.toOrdinalString(fontSize: FontSize.medium, superscriptFontSize: FontSize.superscript, weight: .bold) {
            rankIconGroup.label.attributedText = attString
        } else {
            rankIconGroup.label.text = "N/A"
        }
        
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
        
        setFavorite()
    }
    
    private func setFavorite() {
        do {
            let isFavorite = try self.game!.isInFavorites(skipCache: true)
            self.favoriteButton.set(active: isFavorite)
        } catch let error as InternalError {
            print("\(error.rawValue), id: \(game?.id ?? "")")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    @objc private func favoriteButtonPressed(_ sender: UIButton) throws {
        do {
            let isInFavorites = try game!.isInFavorites()
            try game!.setFavorite(to: !isInFavorites)
            favoriteButton.set(active: !isInFavorites)
        } catch {
            delegate?.didFailToUpdateFavorite(id: game?.id ?? "", error: error)
        }
    }
    
    func clearImage() {
        gameImageView.image = Images.placeholder
    }
}
