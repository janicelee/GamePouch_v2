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
    private let galleryImageBaseURL = "https://api.geekdo.com/api/"
    private init() {}
    
    private func sendRequest(urlComponents: URLComponents, completed: @escaping (Result<Data, GPError>) -> ()) {
        guard let url = urlComponents.url else {
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
            completed(.success(data))
        }
        task.resume()
    }
    
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
                            
                            if id == "330149" {
                                print(game.id)
                            }
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
        let queryItems = [URLQueryItem(name: "type", value: "boardgame")]
        var urlComps = URLComponents(string: baseURL + "hot")!
        urlComps.queryItems = queryItems
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                let parser = HotnessListParser()

                if parser.parse(from: data) {
                    completed(.success(parser.gameIds))
                } else {
                    completed(.failure(.unableToParse))
                }
            case .failure(let error):
                print(error.rawValue)
                // TODO: handle error
            }
        }
    }
    
    func getGameInfo(id: String, completed: @escaping (Result<Game, GPError>) -> ()) {
        let queryItems = [URLQueryItem(name: "type", value: "boardgame, boardgameexpansion"),
                          URLQueryItem(name: "stats", value: "1"),
                          URLQueryItem(name: "id", value: id)]
        var urlComps = URLComponents(string: baseURL + "thing")!
        urlComps.queryItems = queryItems
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                let parser = GameInfoParser()

                if parser.parse(from: data) {
                    completed(.success(parser.game))
                } else {
                    completed(.failure(.unableToParse))
                }
            case .failure(let error):
                print(error.rawValue)
                // TODO: handle error
            }
        }
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage) -> ()) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        let urlComps = URLComponents(string: urlString)!
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            case .failure(let error):
                print(error.rawValue)
                // TODO: handle error (might not need to since images have placeholders)
            }
        }
    }
    
    func getImageGalleryURLs(for id: String, completed: @escaping (Result<[String], GPError>) -> ()) {
        let queryItems = [URLQueryItem(name: "ajax", value: "1"),
                          URLQueryItem(name: "gallery", value: "all"),
                          URLQueryItem(name: "nosession", value: "1"),
                          URLQueryItem(name: "objecttype", value: "thing"),
                          URLQueryItem(name: "pageid", value: "1"),
                          URLQueryItem(name: "showcount", value: "36"),
                          URLQueryItem(name: "size", value: "thumb"),
                          URLQueryItem(name: "sort", value: "hot"),
                          URLQueryItem(name: "objectid", value: id),
        ]
        var urlComps = URLComponents(string: galleryImageBaseURL + "images")!
        urlComps.queryItems = queryItems
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let galleryImages = try decoder.decode(GalleryImages.self, from: data)
                    var result: [String] = []
                    
                    for galleryImage in galleryImages.images {
                        result.append(galleryImage.imageurl_lg)
                    }
                    completed(.success(result))
                } catch {
                    completed(.failure(.unableToParse))
                }
            case .failure(let error):
                print(error.rawValue)
                // TODO: handle error
            }
        }
    }
    
    func search(for query: String, completed: @escaping(Result<[SearchResult], GPError>) -> ()) {
        let queryItems = [URLQueryItem(name: "type", value: "boardgame, boardgameexpansion"), URLQueryItem(name: "query", value: query)]
        var urlComps = URLComponents(string: baseURL + "search")!
        urlComps.queryItems = queryItems
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                let parser = SearchParser()

                if parser.parse(from: data) {
                    completed(.success(parser.searchResults))
                } else {
                    completed(.failure(.unableToParse))
                }
            case .failure(let error):
                print(error.rawValue)
                // TODO: handle error
            }
        }
    }
}
