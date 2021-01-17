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
    let playersIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.players)
    let timeIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.time)
    
    let secondColumn = UIStackView()
    let difficultyIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.difficulty)
    let ageIconGroup = SmallIconGroup(labelText: "N/A", iconImage: Images.age)
    
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
            make.top.equalToSuperview().offset(Layout.smallPadding)
            make.leading.equalToSuperview().offset(Layout.mediumPadding)
            make.bottom.equalToSuperview().offset(-Layout.smallPadding)
            make.width.equalTo(80)
        }
        
        infoContainerView.snp.makeConstraints { make in
            make.top.equalTo(gameImageView)
            make.leading.equalTo(gameImageView.snp.trailing).offset(Layout.smallPadding)
            make.trailing.equalToSuperview().offset(-Layout.mediumPadding)
        }
        
        firstColumn.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        secondColumn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(firstColumn.snp.trailing).offset(Layout.mediumPadding + 8)
        }
    }
    
    func set(favorite: NSManagedObject) {
        titleLabel.text = favorite.value(forKeyPath: "title") as? String ?? ""
        playersIconGroup.label.text = favorite.value(forKeyPath: "players") as? String ?? ""
        timeIconGroup.label.text = favorite.value(forKeyPath: "playTime") as? String ?? ""
        difficultyIconGroup.label.text = favorite.value(forKeyPath: "difficulty") as? String ?? ""
        ageIconGroup.label.text = favorite.value(forKeyPath: "minAge") as? String ?? ""
        
        if let imageURL = favorite.value(forKey: "thumbnailURL") as? String {
            gameImageView.setImage(from: imageURL)
        }
    }
}
