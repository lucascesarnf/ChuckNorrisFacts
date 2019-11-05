//
//  Executor.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

class Executor: ServiceExecutor {
    private var shouldSaveData = true

    var saveData: Bool {
        get {
            return shouldSaveData
        } set {
            shouldSaveData = newValue
        }
    }
}

class MockFailureExecutor: ServiceExecutor {
    var saveData: Bool = false

    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(FactsError.generic))
    }
}

class MockExecutor: ServiceExecutor {
    private var shouldSave = true
    private var jsonFile: String?
    var saveData: Bool {
        get {
            return shouldSave
        } set {
            shouldSave = newValue
        }
    }

    init(jsonInjection: String? = nil) {
        jsonFile = jsonInjection
    }

    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void) {
        let jsonFile = self.jsonFile ?? service.sampleData
        if let data = Self.getDataFromJson(jsonFile: jsonFile) {
            if self.saveData {
                self.saveData(value: data, url: service.urlString)
            }
            DispatchQueue.global(qos: .background).async {
                completion(.success(data))
            }
        }
    }

    static func getDataFromJson(jsonFile: String) -> Data? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
            let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
}
