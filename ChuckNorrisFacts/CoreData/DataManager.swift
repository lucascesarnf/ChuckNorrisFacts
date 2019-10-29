//
//  DataManager.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 29/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import CoreData

struct DataManager {
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "ChuckNorrisFacts")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    mutating func saveData(key: String, value: Data, url: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "EntityData", in: context),
            let valueString =  String(data: value, encoding: String.Encoding.utf8) else { return }
        let entityData = NSManagedObject(entity: entity, insertInto: context)

        entityData.setValue(key, forKey: "key")
        entityData.setValue(valueString, forKey: "value")
        entityData.setValue(url, forKey: "query")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    mutating func loadData(from key: String) -> Data? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityData")
        let predicate = NSPredicate(format: "key == %@", key)
        fetchRequest.predicate = predicate
        do {
            guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else { return nil }

            if let firstResult = results.first, let value = firstResult.value(forKey: "value") as? String {
                return value.data(using: String.Encoding.utf8)
            }
        } catch {
            print("Error is retriving titles items")
            return nil
        }
        return nil
    }
}
