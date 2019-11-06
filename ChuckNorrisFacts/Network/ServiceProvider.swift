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
    var listner: ((Result<Data, Error>) -> Void)?

    init() {
        //Execute Launch argument
        if ProcessInfo.processInfo.arguments.contains("MockNetwork") {
           executor = MockExecutor()
        } else if ProcessInfo.processInfo.arguments.contains("MockNetworkError") {
            executor = MockFailureExecutor()
        }
    }

    convenience init(executor: ServiceExecutor) {
        self.init()
        self.executor = executor
    }

    func execute(service: T) {
        executor.execute(service) { result in
            DispatchQueue.main.async {
                self.listner?(result)
            }
        }
    }

    @discardableResult
    func load<U>(service: T, decodeType: U.Type, deliverQueue: DispatchQueue = DispatchQueue.main,
                 completion: ((Result<U, FactsError>) -> Void)?) -> U? where U: Decodable, T: Service {
        executor.execute(service) { result in
            switch result {
            case .success(let data):
                do {
                    let resp = try decodeType.decode(from: data)
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
            self.listner?(result)
        }
        return ServiceResultManager.loadObject(url: service.urlString, decodeType: decodeType)
    }
}
