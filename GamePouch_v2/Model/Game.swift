//
//  Game.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-01.
//

import UIKit

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
    private lazy var isFavorite: Bool = {
        guard let id = id else { return false }
        do {
            return try CoreDataClient.shared.isFavoriteGame(id: id)
        } catch {
            return false
        }
    }()
    
    
    // MARK: - Getters
    
    func getTitle() -> String {
        guard let name = name, isValidDisplayText(name) else { return "N/A" }
        return name
    }
    
    func getDescription() -> String {
        guard let description = description, isValidDisplayText(description) else { return "N/A" }
        return description
    }
    
    func getYearPublished() -> String {
        guard let yearPublished = yearPublished, isValidDisplayText(yearPublished) else { return "N/A" }
        return yearPublished
    }
    
    func getNumPlayers() -> String {
        guard let minPlayers = minPlayers,
              let maxPlayers = maxPlayers,
              isValidDisplayText(minPlayers),
              isValidDisplayText(maxPlayers) else {
           return "N/A"
        }
        return "\(minPlayers)-\(maxPlayers)"
    }
    
    func getPlayTime() -> String {
        guard let minPlayTime = minPlayTime,
              let maxPlayTime = maxPlayTime,
              isValidDisplayText(minPlayTime),
              isValidDisplayText(maxPlayTime) else {
            return "N/A"
        }
        return "\(minPlayTime)-\(maxPlayTime)"
    }
    
    func getMinAgeDisplayText() -> String {
        guard let minAge = minAge, isValidDisplayText(minAge) else { return "N/A" }
        return "\(minAge)+"
    }
    
    func getRating() -> String {
        guard let rating = rating, isValidDisplayText(rating) else { return "N/A" }
        return rating
    }
    
    func getRank() -> Int?  {
        guard let rank = rank, isValidDisplayText(rank), let num = Int(rank) else { return nil }
        return num
    }
    
    func getDifficultyDisplayText() -> String {
        guard let weight = weight, isValidDisplayText(weight) else { return "N/A" }
        return "\(weight)/5"
    }
    
    private func isValidDisplayText(_ label: String) -> Bool {
        guard !label.isEmpty,
              label != "0",
              label != "0.0",
              label != "Not Ranked" else { return false }
        return true
    }
    
    // MARK: - Favorite Logic
    
    mutating func isInFavorites(skipCache: Bool) throws -> Bool {
        if skipCache {
            guard let id = id else { throw InternalError.unableToVerifyFavorite }
            isFavorite = try CoreDataClient.shared.isFavoriteGame(id: id)
        }
        return isFavorite
    }

    mutating func isInFavorites() throws -> Bool {
        return try isInFavorites(skipCache: false)
    }
    
    mutating func setFavorite(to favorite: Bool) throws {
        if favorite {
            try CoreDataClient.shared.saveFavoriteGame(game: self)
        } else {
            guard let id = id else {
                throw InternalError.unableToDeleteFavorite
            }
            try CoreDataClient.shared.deleteFavoriteGame(id: id)
        }
        self.isFavorite = favorite
    }
}
