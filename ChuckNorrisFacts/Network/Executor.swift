//
//  Executor.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

class Executor: ServiceExecutor {}

class MockFailureExecutor: ServiceExecutor {
    func execute<T: Service>(_ service: T, deliverQueue: DispatchQueue,
                             completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(FactsError.generic))
    }
}

class MockExecutor: ServiceExecutor {
    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = Bundle.main.url(forResource: service.sampleData, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    if service.saveData {
                        self.saveData(value: data, url: service.urlString)
                    }
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
