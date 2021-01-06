//
//  SearchGamesParser.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-04.
//

import Foundation

class SearchParser: NSObject {
    private var searchResult = SearchResult()
    var searchResults = [SearchResult]()
    
    func parse(from data: Data) -> Bool {
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse()
    }
}

extension SearchParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item", let id = attributeDict["id"] {
            searchResult = SearchResult()
            searchResult.id = id
        } else if elementName == "name", let name = attributeDict["value"] {
            searchResult.name = name
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            searchResults.append(searchResult)
        }
    }
}
