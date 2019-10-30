//
//  ServiceProvider.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//
import Foundation

class ServiceProvider<T: Service> {
    var executor: ServiceExecutor = Executor()
    var dataManager = DataManager()

    init() {}

    convenience init(executor: ServiceExecutor) {
        self.init()
        self.executor = executor
    }

    private func loadLocalData<U>(key: String, decodeType: U.Type) -> U? where U: Decodable {
        let decoder = JSONDecoder()

        guard let data = dataManager.loadData(from: key) else { return nil }
        do {
            let resp = try decoder.decode(decodeType, from: data)
            print("✅ Cache Loaded")
            return resp
        } catch {
            print(error)
            return nil
        }
    }

    func load(service: T, deliverQueue: DispatchQueue = DispatchQueue.main,
              completion: @escaping (Result<Data, Error>) -> Void) {
        executor.execute(service, completion: completion)
    }

    @discardableResult
    func load<U>(service: T, decodeType: U.Type, deliverQueue: DispatchQueue = DispatchQueue.main,
                 completion: @escaping (Result<U, FactsError>) -> Void) -> U? where U: Decodable, T: Service {
        executor.execute(service) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    deliverQueue.async {
                        completion(.success(resp))
                    }
                } catch {
                    deliverQueue.async {
                        completion(.failure(FactsError(error: error)))
                    }
                }
            case .failure(let error):
                deliverQueue.async {
                   completion(.failure(FactsError(error: error)))
                }
            }
        }
        return self.loadLocalData(key: service.sampleData, decodeType: decodeType)
    }
}
