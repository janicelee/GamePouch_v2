//
//  Constants.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-11.
//

import UIKit

enum Images {
    static let placeholder = UIImage(named: "game-placeholder")
    static let rank = UIImage(named: "icon-rank")
    static let rating = UIImage(named: "icon-rating")
    static let players = UIImage(named: "icon-players")
    static let difficulty = UIImage(named: "icon-difficulty")
    static let time = UIImage(named: "icon-time")
    static let age = UIImage(named: "icon-age")
    static let filledHeart = UIImage(named: "icon-filled-heart")
    static let emptyHeart = UIImage(named: "icon-empty-heart")
    
    static let tabBarGlyphConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
    static let hotGamesGlyph = UIImage(systemName: "flame", withConfiguration: tabBarGlyphConfig)
    static let searchGlyph = UIImage(systemName: "magnifyingglass", withConfiguration: tabBarGlyphConfig)
    static let favoritesGlyph = UIImage(systemName: "heart", withConfiguration: tabBarGlyphConfig)
}

enum Layout {
    static let xsPadding: CGFloat = 2
    static let smallPadding: CGFloat = 4
    static let mediumPadding: CGFloat = 8
    static let largePadding: CGFloat = 12
    static let xLargePadding: CGFloat = 16
    static let xxLargePadding: CGFloat = 20
}

enum Colors {
    static let purple = UIColor(hex: "#974af0ff")
    static let yellow = UIColor.systemYellow
    static let teal = UIColor.systemTeal
}

enum FontSize {
    static let superscript: CGFloat = 10
    static let small: CGFloat = 14
    static let medium: CGFloat = 16
    static let large: CGFloat = 18
    static let xLarge: CGFloat = 20
}

