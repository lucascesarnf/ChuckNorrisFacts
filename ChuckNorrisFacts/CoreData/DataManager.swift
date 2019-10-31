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
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityData")

    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "ChuckNorrisFacts")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()

    mutating func saveData(value: Data, url: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "EntityData", in: context),
            let valueString =  String(data: value, encoding: String.Encoding.utf8) else { return }
        let entityData = NSManagedObject(entity: entity, insertInto: context)
        resetRecords(for: url)
        entityData.setValue(url, forKey: "key")
        entityData.setValue(valueString, forKey: "value")
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    mutating func loadData(from url: String) -> Data? {
        let predicate = NSPredicate(format: "key == %@", url)
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

    mutating func resetRecords(for url: String) {
         let predicate = NSPredicate(format: "key == %@", url)
         fetchRequest.predicate = predicate
        do {
            guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
            results.forEach { result in context.delete(result)}
            try context.save()
        } catch {
            print("There was an error")
        }
    }

    mutating func loadObject<U>(url: String, decodeType: U.Type) -> U? where U: Decodable {
        let decoder = JSONDecoder()

        guard let data = self.loadData(from: url) else { return nil }
        do {
            let resp = try decoder.decode(decodeType, from: data)
            print("✅ Cache Loaded")
            return resp
        } catch {
            print(error)
            return nil
        }
    }

    mutating func reset() {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
