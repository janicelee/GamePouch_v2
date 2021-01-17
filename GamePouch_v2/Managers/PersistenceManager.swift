//
//  PersistenceManager.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-16.
//

import UIKit
import CoreData

enum PersistenceManager {
    
    static func saveFavorite(game: Game) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        
        favorite.setValue(game.id ?? "", forKey: "id")
        favorite.setValue(game.thumbnailURL ?? "", forKey: "thumbnailURL")
        favorite.setValue(game.getTitle(), forKey: "title")
        favorite.setValue(game.getNumPlayers(), forKey: "players")
        favorite.setValue(game.getPlayTime(), forKey: "playTime")
        favorite.setValue(game.getDifficulty(), forKey: "difficulty")
        favorite.setValue(game.getMinAge(), forKey: "minAge")
        favorite.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func saveSearch(id: String, name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Search", in: managedContext)!
        let search = NSManagedObject(entity: entity, insertInto: managedContext)

        search.setValue(id, forKey: "id")
        search.setValue(name, forKey: "name")
        search.setValue(Date(), forKey: "date")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Search")
            let count = try managedContext.count(for: fetchRequest)

            if count > 5 {
                let sort = NSSortDescriptor(key: "date", ascending: true)
                fetchRequest.sortDescriptors = [sort]
                fetchRequest.fetchLimit = 1

                let oldestSearch = try managedContext.fetch(fetchRequest)
                if oldestSearch.count == 1 {
                    managedContext.delete(oldestSearch[0])
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchFavorites(completed: @escaping (NSAsynchronousFetchResult<NSManagedObject>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in
            completed(result)
        }
        
        do {
            try managedContext.execute(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func fetchRecentSearches() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Search")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
    
        do {
            let recentSearches = try managedContext.fetch(fetchRequest)
            return recentSearches
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
