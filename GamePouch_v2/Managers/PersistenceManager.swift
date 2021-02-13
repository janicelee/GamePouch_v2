//
//  PersistenceManager.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-16.
//

import UIKit
import CoreData

enum PersistenceManager {
    static let searchEntity = "Search"
    
    static func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Search Result Methods
    
    static func saveSearch(id: String, name: String) {
        guard let managedContext = getManagedContext() else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: searchEntity, in: managedContext)!
        let search = NSManagedObject(entity: entity, insertInto: managedContext)

        search.setValue(id, forKey: "id")
        search.setValue(name, forKey: "name")
        search.setValue(Date(), forKey: "date")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save search. \(error), \(error.userInfo)")
        }
        
        // If there are more than five saved searches, delete the oldest search
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: searchEntity)
            let count = try managedContext.count(for: fetchRequest)

            if count > 5 {
                let sort = NSSortDescriptor(key: "date", ascending: true)
                fetchRequest.sortDescriptors = [sort]
                fetchRequest.fetchLimit = 1

                let oldestSearch = try managedContext.fetch(fetchRequest)
                if oldestSearch.count == 1 {
                    managedContext.delete(oldestSearch[0])
                    try managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Error occurred while maintaining max number of saved searches. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchRecentSearches() -> [SearchResult] {
        guard let managedContext = getManagedContext() else { return [] }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: searchEntity)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
    
        do {
            let recentSearches = try managedContext.fetch(fetchRequest)
            return parseRecentSearches(searches: recentSearches)
        } catch let error as NSError {
            print("Could not fetch recent searches. \(error), \(error.userInfo)")
        }
        return []
    }
    
    static func parseRecentSearches(searches: [NSManagedObject]) -> [SearchResult] {
        var searchResults: [SearchResult] = []
        
        searches.forEach {
            if let id = $0.value(forKeyPath: "id") as? String,
               let name = $0.value(forKeyPath: "name") as? String {
                searchResults.append(SearchResult(id: id, name: name))
            }
        }
        return searchResults
    }
    
    // MARK: - Favorite Methods
    
    static func saveFavorite(game: Game) throws {
        guard let managedContext = getManagedContext() else {
            throw InternalError.unableToRetrieveManagedContext
        }

        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)

        favorite.setValue(game.id ?? "", forKey: "id")
        favorite.setValue(game.getTitle(), forKey: "title")
        favorite.setValue(Date(), forKey: "date")

        do {
            try managedContext.save()
        } catch _ as NSError {
            throw InternalError.unableToSaveFavorite
        }
    }
    
    static func deleteFavorite(gameId: String) throws {
        guard let managedContext = getManagedContext() else {
            throw InternalError.unableToRetrieveManagedContext
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id = %@", gameId)
        
        do {
            let favorite = try managedContext.fetch(fetchRequest)
            managedContext.delete(favorite[0])
            try managedContext.save()
        } catch _ as NSError {
            throw InternalError.unableToDeleteFavorite
        }
    }
    
    static func isFavorite(id: String) throws -> Bool {
        guard let managedContext = getManagedContext() else {
            throw InternalError.unableToRetrieveManagedContext
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let count = try managedContext.fetch(fetchRequest).count
            return (count < 1) ? false : true
        } catch _ as NSError {
            throw InternalError.unableToVerifyFavorite
        }
    }
    
    static func fetchFavoriteGameRefsObjects(completed: @escaping (Result<NSAsynchronousFetchResult<NSManagedObject>, Error>) -> ()) {
        guard let managedContext = getManagedContext() else {
            completed(.failure(InternalError.unableToRetrieveManagedContext))
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
            completed(.success(result))
        }
        
        do {
            try managedContext.execute(asyncFetchRequest)
        } catch _ as NSError {
            completed(.failure(InternalError.unableToRetrieveFavorites)) 
        }
    }
    
    static func fetchFavorites(completed: @escaping (Result<[Game], Error>) -> ()) {
        PersistenceManager.fetchFavoriteGameRefsObjects { result in
            switch result {
            case .success(let gameRefObjResult):
                if let gameRefObj = gameRefObjResult.finalResult {
                    var games: [Game?] = Array(repeating: nil, count: gameRefObj.count)
                    let group = DispatchGroup()
                    
                    for (index, object) in gameRefObj.enumerated() {
                        group.enter()
                        
                        if let id = object.value(forKeyPath: "id") as? String {
                            NetworkManager.shared.getGameInfo(id: id) { result in
                                switch result {
                                case .success(let game):
                                    games.insert(game, at: index)
                                case .failure(let error):
                                    print("Error retrieving game info for id: \(id), error: \(error.rawValue)")
                                }
                                group.leave()
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        let compactedGames = games.compactMap{$0}
                        completed(.success(compactedGames))
                    }
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
}
