//
//  GameInfoParser.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-04.
//

import Foundation

class GameInfoParser: NSObject {
    var game = Game()
    private var elementName = ""
    private var foundCharacters = ""
    
    func parse(from data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension GameInfoParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            game.id =  attributeDict["id"]
        } else if elementName == "thumbnail" || elementName == "image" || elementName == "description" {
            self.elementName = elementName
        } else if elementName == "name" && attributeDict["type"] == "primary" {
            game.name = attributeDict["value"]
        } else if elementName == "yearpublished" {
            game.yearPublished = attributeDict["value"]
        } else if elementName == "minplayers" {
            game.minPlayers = attributeDict["value"]
        } else if elementName == "maxplayers" {
            game.maxPlayers = attributeDict["value"]
        } else if elementName == "minplaytime" {
            game.minPlayTime = attributeDict["value"]
        } else if elementName == "maxplaytime" {
            game.maxPlayTime = attributeDict["value"]
        } else if elementName == "minage" {
            game.minAge = attributeDict["value"]
        } else if elementName == "link" && attributeDict["type"] == "boardgamecategory" {
            if let category = attributeDict["value"] {
                game.categories.append(category)
            }
        } else if elementName == "link" && attributeDict["type"] == "boardgamemechanic" {
            if let mechanic = attributeDict["value"] {
                game.mechanics.append(mechanic)
            }
        } else if elementName == "average" {
            game.rating = attributeDict["value"]
        }  else if elementName == "rank" && attributeDict["name"] == "boardgame" {
            game.rank = attributeDict["value"]
        } else if elementName == "averageweight" {
            game.weight = attributeDict["value"]
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "thumbnail" {
            game.thumbnailURL = foundCharacters
        } else if elementName == "image" {
            game.imageURL = foundCharacters
        } else if elementName == "description" {
            var description = foundCharacters.replacingOccurrences(of: "&#10;", with: "\n")
            description = description.replacingOccurrences(of: "&ldquo;", with: "\"")
            description = description.replacingOccurrences(of: "&rdquo;", with: "\"")
            description = description.replacingOccurrences(of: "&lsquo;", with: "'")
            description = description.replacingOccurrences(of: "&rsquo;", with: "'")
            description = description.replacingOccurrences(of: "&mdash;", with: "-")
            game.description = description
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            if self.elementName == "thumbnail" || self.elementName == "image" || self.elementName == "description" {
                self.foundCharacters += data
            }
        }
    }
}
