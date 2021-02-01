//
//  HotnessListParser.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-02.
//

import Foundation

class HotnessListParser: NSObject {
    var gameIds: [String] = []
    
    func parse(from data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension HotnessListParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item", let id = attributeDict["id"] {
            gameIds.append(id)
        }
    }
}
