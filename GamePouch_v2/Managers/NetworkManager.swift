//
//  NetworkManager.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-01.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://www.boardgamegeek.com/xmlapi2/"
    private let getGameURL = "thing?type=boardgame,boardgameexpansion&stats=1&id="
    private let hotnessListURL = "hot?type=boardgame"
    
    private init() {}
    
    func getHotnessList(completed: @escaping (Result<[String], GPError>) -> ()) {
        let endpoint = baseURL + hotnessListURL
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            let parser = HotnessListParser()
            
            if parser.parse(from: data) {
                completed(.success(parser.gameIds))
            } else {
                completed(.failure(.unableToParse))
            }
        }
        task.resume()
    }
    
    func getGameInfo(id: String, completed: @escaping (Result<Game, GPError>) -> ()) {
        let endpoint = baseURL + getGameURL + id
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            let parser = GameInfoParser()

            if parser.parse(from: data) {
                completed(.success(parser.game))
            } else {
                completed(.failure(.unableToParse))
            }
        }
        task.resume()
    }
}
