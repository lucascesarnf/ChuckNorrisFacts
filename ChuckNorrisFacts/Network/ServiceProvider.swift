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
    
    init() {}
    convenience init(executor: ServiceExecutor) {
        self.init()
        self.executor = executor
    }
    
    func load(service: T, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<Data, Error>) -> Void) {
        executor.execute(service, completion: completion)
    }
    
    func load<U>(service: T, decodeType: U.Type, deliverQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<U, Error>) -> Void) where U: Decodable {
        executor.execute(service) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(decodeType, from: data)
                    completion(.success(resp))
                }
                catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
