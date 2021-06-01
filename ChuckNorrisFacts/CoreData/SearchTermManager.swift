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

    static func saveObject(term: String, time: Date) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return }
        let entityData = NSManagedObject(entity: entity, insertInto: context)
        entityData.setValue(term, forKey: "term")
        entityData.setValue(time, forKey: "time")
        context.performAndWait {
            try? context.save()
        }
    }

    static func loadObject() -> [String] {
        guard var results = try? context.fetch(fetchRequest) as? [NSManagedObject] else { return [] }
        results = results.sorted(by: {
            let currentTime = ($0.value(forKey: "time") as? Date) ?? Date()
            let nextTime = ($1.value(forKey: "time") as? Date) ?? Date()
            return currentTime > nextTime
        })
        let test = results.map({($0.value(forKey: "term") as? String) ?? ""})
        return test
    }

    static func updateObject(term: String, time: Date) {
        let predicate = NSPredicate(format: "term == %@", term)
        fetchRequest.predicate = predicate
        if let results = try? context.fetch(fetchRequest) as? [NSManagedObject], let firstResult = results.first {
            firstResult.setValue(time, forKey: "time")
        }
        context.performAndWait {
            try? context.save()
        }
        fetchRequest.predicate = nil
    }

    static func removeObject(term: String) {
        let predicate = NSPredicate(format: "term == %@", term)
        fetchRequest.predicate = predicate
        if let results = try? context.fetch(fetchRequest) as? [NSManagedObject], let firstResult = results.first {
            context.performAndWait {
                context.delete(firstResult)
                try? context.save()
            }
            fetchRequest.predicate = nil
        }
    }

    static func saveContext () {
        if context.hasChanges {
            try? context.save()
        }
    }

    static func reset() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        context.performAndWait {
            _ = try? context.execute(deleteRequest)
        }
    }
}
