//
//  GameCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-03.
//

import UIKit

class GameCell: UITableViewCell {
    static let reuseID = "GameCell"
    
    let gameImageView = GameImageView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(gameImageView)
        
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: self.topAnchor),
            gameImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            gameImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            gameImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func set(game: Game) {
        if let imageURL = game.imageURL {
            gameImageView.setImage(from: imageURL)
        }
    }
}
