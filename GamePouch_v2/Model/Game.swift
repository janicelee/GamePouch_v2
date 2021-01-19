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
    private var isFavorite: Bool?
    
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
    
    func getRank() -> (text: String, attributedString: NSMutableAttributedString?)  {
        guard let rank = rank, isValid(rank), let rankInt = Int(rank) else { return ("N/A", nil) }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        
        let rankNSNumber = NSNumber(value: rankInt)
        guard var result = formatter.string(from: rankNSNumber) else { return ("N/A", nil) }
        result = result.replacingOccurrences(of: ",", with: "")
        
        let font: UIFont? = UIFont.systemFont(ofSize: 15, weight: .bold)
        let fontSuper: UIFont? = UIFont.systemFont(ofSize: 10, weight: .bold)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font: font!])
        let location = result.count - 2
        
        attString.setAttributes([.font: fontSuper!,.baselineOffset: 5], range: NSRange(location: location, length: 2))
        return (result, attString)
    }
    
    func getDifficulty() -> String {
        guard let weight = weight, isValid(weight) else {
            return "N/A"
        }
       return "\(weight)/5"
    }

    mutating func isInFavorites() -> Bool {
        if isFavorite == nil {
            guard let id = id else { return false }
            isFavorite = PersistenceManager.isFavourite(id: id)
        }
        return isFavorite!
    }
    
    mutating func setFavorite(to value: Bool) {
        isFavorite = value
    }
    
    private func isValid(_ label: String) -> Bool {
        return !label.isEmpty && label != "0" && label != "0.0" && label != "Not Ranked"
    }
}
