//
//  ServiceResultManager.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 29/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import CoreData

struct ServiceResultManager {
    static let entityName = "EntityData"
    static let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

    static var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: applicationName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    static func saveData(value: Data, url: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context),
            let valueString =  String(data: value, encoding: String.Encoding.utf8) else { return }
        let entityData = NSManagedObject(entity: entity, insertInto: context)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        entityData.setValue(url, forKey: "key")
        entityData.setValue(valueString, forKey: "value")
        context.performAndWait {
            try? context.save()
        }
    }

    static func loadRandonObjects<U>(numberOfResults: Int = 3, decodeType: U.Type) -> [U] where U: Decodable {
        guard let results =  try? context.fetch(fetchRequest) as? [NSManagedObject] else { return [] }
        var randonResults = [U]()
        for result in results.choose(numberOfResults) {
            if let value = result.value(forKey: "value") as? String, let data = value.data(using: String.Encoding.utf8),
                let resp = try? decodeType.decode(from: data) {
                randonResults.append(resp)
            }
        }
        return randonResults
    }

    static func loadData(from url: String) -> Data? {
        let predicate = NSPredicate(format: "key == %@", url)
        fetchRequest.predicate = predicate
        guard let results = try? context.fetch(fetchRequest) as? [NSManagedObject], let firstResult = results.first,
            let value = firstResult.value(forKey: "value") as? String else { return nil }
        fetchRequest.predicate = nil
        return value.data(using: String.Encoding.utf8)
    }

    static func loadObject<U>(url: String, decodeType: U.Type) -> U? where U: Decodable {
        guard let data = self.loadData(from: url) else { return nil }
        let resp = try? decodeType.decode(from: data)
        print("✅ Cache Loaded")
        return resp
    }

    static func removeObject(url: String) {
        let predicate = NSPredicate(format: "key == %@", url)
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
