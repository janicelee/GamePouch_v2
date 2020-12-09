//
//  Game.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-01.
//

import Foundation

struct Game {
    var id: String?
    var thumbnailURL: String?
    var imageURL: String?
    var name: String?
    var description: String?
    var yearPublished: String?
    var minPlayers: String?
    var maxPlayers: String?
    var minPlayTime: String?
    var maxPlayTime: String?
    var minAge: String?
    var categories: [String] = []
    var mechanics: [String] = []
    var rating: String?
    var rank: String?
    var weight: String?
}
