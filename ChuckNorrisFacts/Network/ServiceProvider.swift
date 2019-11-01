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
    var executeListner: ((Result<Data, Error>) -> Void)?

    init() {
        //Execute Launch argument
        if ProcessInfo.processInfo.arguments.contains("MockNewtwork") {
           executor = MockExecutor()
        }
    }

    convenience init(executor: ServiceExecutor) {
        self.init()
        self.executor = executor
    }

    func load(service: T, deliverQueue: DispatchQueue = DispatchQueue.main,
              completion: @escaping (Result<Data, Error>) -> Void) {
        executor.execute(service, completion: completion)
    }

    func execute(service: T) {
        executor.execute(service) { result in
            self.executeListner?(result)
        }
    }

    @discardableResult
    func load<U>(service: T, decodeType: U.Type, deliverQueue: DispatchQueue = DispatchQueue.main,
                 completion: ((Result<U, FactsError>) -> Void)?) -> U? where U: Decodable, T: Service {
        executor.execute(service) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    deliverQueue.async {
                        completion?(.success(resp))
                    }
                } catch {
                    deliverQueue.async {
                        completion?(.failure(FactsError(error: error)))
                    }
                }
            case .failure(let error):
                deliverQueue.async {
                   completion?(.failure(FactsError(error: error)))
                }
            }
        }
        return dataManager.loadObject(url: service.urlString, decodeType: decodeType)
    }
}
