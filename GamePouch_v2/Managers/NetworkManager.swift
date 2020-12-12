//
//  NetworkManager.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2020-12-01.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private let baseURL = "https://www.boardgamegeek.com/xmlapi2/"
    private let getGameURL = "thing?type=boardgame,boardgameexpansion&stats=1&id="
    private let hotnessListURL = "hot?type=boardgame"
    
    private init() {}
    
    func getHotnessList(completed: @escaping (Result<[Game], GPError>) -> ()) {
        NetworkManager.shared.getHotnessListIds { result in
            switch result {
            case .success(let ids):
                var games: [Game?] = Array(repeating: nil, count: ids.count)
                let group = DispatchGroup()
                
                for (index, id) in ids.enumerated() {
                    group.enter()
                    
                    NetworkManager.shared.getGameInfo(id: id) { result in
                        switch result {
                        case .success(let game):
                            games.insert(game, at: index)
                        case .failure(let error):
                            print("Failed to get data for game id: \(id), error: \(error.rawValue)")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completed(.success(games.compactMap{$0}))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    private func getHotnessListIds(completed: @escaping (Result<[String], GPError>) -> ()) {
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
    
    private func getGameInfo(id: String, completed: @escaping (Result<Game, GPError>) -> ()) {
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
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage) -> ()) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
    
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
            }
        task.resume()
    }
}
