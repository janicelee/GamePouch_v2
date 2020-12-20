//
//  Game.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-01.
//

import Foundation
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
    
    func getTitle() -> String {
        guard let name = name, isValid(name) else { return "N/A" }
        return name
    }
    
    func getDescription() -> String {
        guard let description = description, isValid(description) else { return "N/A" }
        return description
    }
    
    func getYearPublished() -> String {
        guard let yearPublished = yearPublished, isValid(yearPublished) else { return "N/A" }
        return yearPublished
    }
    
    func getNumPlayers() -> String {
        guard let minPlayers = minPlayers, let maxPlayers = maxPlayers, isValid(minPlayers), isValid(maxPlayers) else {
           return "N/A"
        }
        return "\(minPlayers)-\(maxPlayers)"
    }
    
    func getPlayTime() -> String {
        guard let minPlayTime = minPlayTime, let maxPlayTime = maxPlayTime, isValid(minPlayTime), isValid(maxPlayTime) else {
            return "N/A"
        }
        return "\(minPlayTime)-\(maxPlayTime)"
    }
    
    func getMinAge() -> String {
        guard let minAge = minAge, isValid(minAge) else { return "N/A" }
        return "\(minAge)+"
    }
    
    func getRating() -> String {
        guard let rating = rating, isValid(rating) else { return "N/A" }
        return rating
    }
    
    func getRank() -> String {
        guard let rank = rank, isValid(rank) else { return "N/A" }
        return rank
    }
    
    func getDifficulty() -> String {
        guard let weight = weight, isValid(weight) else {
            return "N/A"
        }
       return "\(weight)/5"
    }
    
    private func isValid(_ label: String) -> Bool {
        return !label.isEmpty && label != "0" && label != "0.0" && label != "Not Ranked"
    }
}
