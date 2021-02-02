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
    private var isFavorite: Bool?
    
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
        guard let minPlayers = minPlayers, let maxPlayers = maxPlayers, isValidDisplayText(minPlayers), isValidDisplayText(maxPlayers) else {
           return "N/A"
        }
        return "\(minPlayers)-\(maxPlayers)"
    }
    
    func getPlayTime() -> String {
        guard let minPlayTime = minPlayTime, let maxPlayTime = maxPlayTime, isValidDisplayText(minPlayTime), isValidDisplayText(maxPlayTime) else {
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
    
    func getRankDisplayText() -> (text: String, attributedString: NSMutableAttributedString?)  {
        guard let rank = rank, isValidDisplayText(rank), let rankInt = Int(rank) else { return ("N/A", nil) }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        let rankNSNumber = NSNumber(value: rankInt)
        guard var result = formatter.string(from: rankNSNumber) else { return ("N/A", nil) }
        result = result.replacingOccurrences(of: ",", with: "")
        
        let font: UIFont? = UIFont.systemFont(ofSize: FontSize.medium, weight: .bold)
        let fontSuper: UIFont? = UIFont.systemFont(ofSize: FontSize.superscript, weight: .bold)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font: font!])
        let location = result.count - 2
        
        attString.setAttributes([.font: fontSuper!,.baselineOffset: 5], range: NSRange(location: location, length: 2))
        return (result, attString)
    }
    
    func getDifficultyDisplayText() -> String {
        guard let weight = weight, isValidDisplayText(weight) else { return "N/A" }
        return "\(weight)/5"
    }
    
    mutating func isInFavorites(skipCache: Bool) -> Bool {
        if isFavorite == nil || skipCache {
            guard let id = id else { return false }
            isFavorite = PersistenceManager.isFavourite(id: id)
        }
        return isFavorite!
    }

    mutating func isInFavorites() -> Bool {
        return isInFavorites(skipCache: false)
    }
    
    mutating func setFavorite(to isFavorite: Bool) {
        self.isFavorite = isFavorite
        
        if isFavorite {
            PersistenceManager.saveFavorite(game: self)
        } else {
            guard let id = id else { return } // TODO: show error?
            PersistenceManager.deleteFavorite(gameId: id)
        }
    }
    
    private func isValidDisplayText(_ label: String) -> Bool {
        return !label.isEmpty && label != "0" && label != "0.0" && label != "Not Ranked"
    }
}
