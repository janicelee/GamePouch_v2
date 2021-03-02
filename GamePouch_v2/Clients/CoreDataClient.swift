//
//  CoreDataClient.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-16.
//

import UIKit
import CoreData

class CoreDataClient {
    static let shared = CoreDataClient()
    
    private let searchEntity = "Search"
    private let favoriteEntity = "Favorite"
    private let maxNumSearches = 5
    
    private init() {}
    
    private func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Search Result Methods
    
    func saveSearch(id: String, name: String) {
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
        deleteOldestSearchIfNecessary()
    }
    
    // If number of saved searches exceeds max, delete oldest search
    
    private func deleteOldestSearchIfNecessary() {
        guard let managedContext = getManagedContext() else { return }
        
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: searchEntity)
            let count = try managedContext.count(for: fetchRequest)

            if count > maxNumSearches {
                let sort = NSSortDescriptor(key: "date", ascending: true)
                fetchRequest.sortDescriptors = [sort]
                fetchRequest.fetchLimit = 1 // get oldest search

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
    
    func fetchRecentSearches() -> [SearchResult] {
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
    
    private func parseRecentSearches(searches: [NSManagedObject]) -> [SearchResult] {
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
    
    func saveFavoriteGame(game: Game) throws {
        guard let managedContext = getManagedContext() else {
            throw InternalError.unableToRetrieveManagedContext
        }

        let entity = NSEntityDescription.entity(forEntityName: favoriteEntity, in: managedContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)

        favorite.setValue(game.id ?? "", forKey: "id")
        favorite.setValue(game.getTitle(), forKey: "title")
        favorite.setValue(Date(), forKey: "date")

        do {
            try managedContext.save()
        } catch {
            throw InternalError.unableToSaveFavorite
        }
    }
    
    func deleteFavoriteGame(id: String) throws {
        guard let managedContext = getManagedContext() else {
            throw InternalError.unableToRetrieveManagedContext
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favoriteEntity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let favorite = try managedContext.fetch(fetchRequest)
            managedContext.delete(favorite[0])
            try managedContext.save()
        } catch {
            throw InternalError.unableToDeleteFavorite
        }
    }
    
    func isFavoriteGame(id: String) throws -> Bool {
        guard let managedContext = getManagedContext() else {
            throw InternalError.unableToRetrieveManagedContext
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favoriteEntity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let count = try managedContext.fetch(fetchRequest).count
            return (count < 1) ? false : true
        } catch {
            throw InternalError.unableToVerifyFavorite
        }
    }
    
    func fetchFavoriteGames(completed: @escaping (Result<[Game], Error>) -> ()) {
        CoreDataClient.shared.fetchFavoriteGameRefs { result in
            switch result {
            case .success(let gameRefsResult):
                guard let gameRefs = gameRefsResult.finalResult else {
                    completed(.failure(InternalError.unableToRetrieveFavorites))
                    return
                }
                CoreDataClient.shared.getGamesFromRefs(refs: gameRefs) { games in
                    completed(.success(games))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    private func fetchFavoriteGameRefs(completed: @escaping (Result<NSAsynchronousFetchResult<NSManagedObject>, Error>) -> ()) {
        guard let managedContext = getManagedContext() else {
            completed(.failure(InternalError.unableToRetrieveManagedContext))
            return
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favoriteEntity)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
            completed(.success(result))
        }
        
        do {
            try managedContext.execute(asyncFetchRequest)
        } catch {
            completed(.failure(InternalError.unableToRetrieveFavorites)) 
        }
    }
    
    private func getGamesFromRefs(refs: [NSManagedObject], completed: @escaping([Game]) -> ()) {
        var games: [Game?] = Array(repeating: nil, count: refs.count)
        let group = DispatchGroup()
        
        for (index, object) in refs.enumerated() {
            group.enter()
            
            if let id = object.value(forKeyPath: "id") as? String {
                BoardGameGeekClient.shared.getGame(id: id) { result in
                    switch result {
                    case .success(let game):
                        games.insert(game, at: index)
                    case .failure(let error):
                        // Skip game in case of error
                        print("Error retrieving game info for id: \(id), error: \(error.rawValue)")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completed(games.compactMap{$0})
        }
    }
}
