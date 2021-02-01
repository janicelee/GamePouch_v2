//
//  PersistenceManager.swift
//  GamePouch_v2
//
//  Created by Janice Lee on 2021-01-16.
//

import UIKit
import CoreData

enum PersistenceManager {
    
    // MARK: - Search Result Methods
    
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
    
    // MARK: - Favorite Methods
    
    static func saveFavorite(game: Game) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        
        favorite.setValue(game.id ?? "", forKey: "id")
        favorite.setValue(game.getTitle(), forKey: "title")
        favorite.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func deleteFavorite(gameId: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id = %@", gameId)
        
        do {
            let favorite = try managedContext.fetch(fetchRequest)
            managedContext.delete(favorite[0])
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete id: \(gameId), error: \(error), \(error.userInfo)")
        }
    }
    
    static func isFavourite(id: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let count = try managedContext.fetch(fetchRequest).count
            return (count < 1) ? false : true
        } catch let error as NSError {
            print("Could not fetch info for this favourite, id: \(id), error: \(error), \(error.userInfo)")
        }
        return false
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
}
