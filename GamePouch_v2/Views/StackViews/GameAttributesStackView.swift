//
//  GameAttributesStackView.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-02-08.
//

import UIKit

class GameAttributesStackView: UIStackView {
    
    let playersIconGroup = GameInfoIconGroup(labelText: "N/A", icon: Images.players)
    let timeIconGroup = GameInfoIconGroup(labelText: "N/A", icon: Images.time)
    let difficultyIconGroup = GameInfoIconGroup(labelText: "N/A", icon: Images.difficulty)
    let ageIconGroup = GameInfoIconGroup(labelText: "N/A", icon: Images.age)
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributeLabels(for game: Game) {
        playersIconGroup.label.text = "\(game.getNumPlayers())\nPlayers"
        playersIconGroup.label.accessibilityLabel = "Number of players: \(formatGameLabelToAccessibleText(game.getNumPlayers()))"
        
        timeIconGroup.label.text = "\(game.getPlayTime())\nMinutes"
        timeIconGroup.label.accessibilityLabel = "Play time: \(formatGameLabelToAccessibleText(game.getPlayTime())) minutes"
        
        difficultyIconGroup.label.text = "\(game.getDifficultyDisplayText())\nDifficulty"
        difficultyIconGroup.label.accessibilityLabel = "Difficulty: \(formatGameLabelToAccessibleText(game.getDifficultyDisplayText()))"
        
        ageIconGroup.label.text = "\(game.getMinAgeDisplayText())\nYears"
        ageIconGroup.label.accessibilityLabel = "Minimum age: \(formatGameLabelToAccessibleText(game.getMinAgeDisplayText()))"
    }
    
    // MARK: - Configuration
    
    private func configure() {
        distribution = .fillEqually
        
        [playersIconGroup, timeIconGroup, difficultyIconGroup, ageIconGroup].forEach {
            addArrangedSubview($0)
            $0.label.numberOfLines = 2
        }
    }
}
