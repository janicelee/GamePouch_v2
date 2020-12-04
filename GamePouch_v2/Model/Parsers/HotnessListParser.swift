//
//  HotnessListParser.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-02.
//

import Foundation

class HotnessListParser: NSObject {
    private var tempGame: Game?
    var games: [Game] = []
    
    func parse(from data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension HotnessListParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            tempGame = Game()
            tempGame?.id = attributeDict["id"]
        } else if elementName == "thumbnail" {
            tempGame?.thumbnailURL = attributeDict["value"]
        } else if elementName == "name" {
            tempGame?.name = attributeDict["value"]
        } else if elementName == "yearpublished" {
            tempGame?.yearPublished = attributeDict["value"]
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            guard tempGame?.id != nil else { return }
            games.append(tempGame!)
        }
    }
}
