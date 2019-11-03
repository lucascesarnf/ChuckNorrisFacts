//
//  SearchTermManager.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 02/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import CoreData

struct SearchTermManager {
    static let entityName = "SearchTerm"
    static let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    private static let maxNumberOfTerms = 8

    static var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: applicationName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    static func saveData(term: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let entityData = NSManagedObject(entity: entity, insertInto: context)
        entityData.setValue(term, forKey: "term")
        context.performAndWait {
            do {
                try? context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    static func loadData() -> [String] {
        do {
            if let results = try? context.fetch(fetchRequest) as? [NSManagedObject] {
                let test = results.map({($0.value(forKey: "term") as? String)†})
                return test
            }
        } catch {
            print("Error is retriving titles items")
        }
        return []
    }
}
