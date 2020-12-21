//
//  GameInfoViewController.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-18.
//

import UIKit
import SnapKit

class GameInfoViewController: UIViewController {
    
    var game: Game!
    
    let scrollView = UIScrollView()
    let gameImageView = GameImageView(frame: .zero)
    
    let largeIconView = UIView()
    let ratingIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rating)
    let rankIconGroup = LargeIconGroup(labelText: "N/A", iconImage: Images.rank)
    
    let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    let yearLabel = UILabel()
    
    let rowStackView = UIStackView()
    let playersIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.time)
    let difficultyIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = VerticalLargeIconGroup(labelText: "N/A", iconImage: Images.age)
    
    let descriptionLabel = UILabel()
    
    let leftEdgePadding: CGFloat = 20
    let verticalPadding: CGFloat = 8
    
    init(game: Game) {
        super.init(nibName: nil, bundle: nil)
        self.game = game
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        ratingIconGroup.label.text = game.getRating()
        setRankText(rank: game.getRank())
        titleLabel.text = game.getTitle()
        yearLabel.text = game.getYearPublished()
        playersIconGroup.label.text = "\(game.getNumPlayers())\nPlayers"
        timeIconGroup.label.text = "\(game.getPlayTime())\nMinutes"
        difficultyIconGroup.label.text = "\(game.getDifficulty())\nDifficulty"
        ageIconGroup.label.text = "\(game.getMinAge())\nYears"
        descriptionLabel.text = game.getDescription()
        
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    
        configureGameImageView()
        configureLargeIconView()
        configureTitleLabels()
        configureRowStackView()
        configureDescriptionLabel()
    }
    
    private func configureGameImageView() {
        scrollView.addSubview(gameImageView)
        
        gameImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view)
            make.height.equalTo(300)
        }
    }
    
    private func configureLargeIconView() {
        scrollView.addSubview(largeIconView)
        [ratingIconGroup, rankIconGroup].forEach { largeIconView.addSubview($0) }
        
        largeIconView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(leftEdgePadding)
            make.trailing.equalTo(view)
        }
        
        ratingIconGroup.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview()
        }
        
        rankIconGroup.snp.makeConstraints { make in
            make.leading.equalTo(ratingIconGroup.snp.trailing).offset(20)
            make.centerY.equalTo(ratingIconGroup.snp.centerY)
        }
    }
    
    private func configureTitleLabels() {
        [titleLabel, yearLabel].forEach { scrollView.addSubview($0) }
        
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.9

        yearLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        yearLabel.textColor = .secondaryLabel
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(largeIconView.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(leftEdgePadding)
            make.trailing.equalTo(view).offset(-leftEdgePadding)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(leftEdgePadding + 2)
            make.trailing.equalTo(view)
        }
    }
    
    private func configureRowStackView() {
        scrollView.addSubview(rowStackView)
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach { rowStackView.addArrangedSubview($0)
        }
        
        rowStackView.backgroundColor = .systemBackground
        rowStackView.distribution = .fillEqually
        
        playersIconGroup.label.numberOfLines = 2
        timeIconGroup.label.numberOfLines = 2
        difficultyIconGroup.label.numberOfLines = 2
        ageIconGroup.label.numberOfLines = 2
        
        rowStackView.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(8)
            make.trailing.equalTo(view).offset(-8)
        }
    }
    
    private func configureDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.backgroundColor = .systemRed
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(rowStackView.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(view).offset(leftEdgePadding)
            make.trailing.equalTo(view).offset(-leftEdgePadding)
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setRankText(rank: String) {
        rankIconGroup.label.text = rank
        guard rank != "N/A" else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        if let rankInt = Int(rank) {
            let rankNSNumber = NSNumber(value: rankInt)
            guard var result = formatter.string(from: rankNSNumber) else { return }
            result = result.replacingOccurrences(of: ",", with: "")
            
            let font: UIFont? = UIFont.systemFont(ofSize: 15, weight: .bold)
            let fontSuper: UIFont? = UIFont.systemFont(ofSize: 10, weight: .bold)
            let attString: NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
            let location = result.count - 2
            
            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location: location, length:2))
            rankIconGroup.label.attributedText = attString
        }
    }

}
