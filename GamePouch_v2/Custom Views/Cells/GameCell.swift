//
//  GameCell.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-03.
//

import UIKit

class GameCell: UITableViewCell {
    static let reuseID = "GameCell"
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemRed
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func set(game: Game) {
        label.text = game.name
    }
}
