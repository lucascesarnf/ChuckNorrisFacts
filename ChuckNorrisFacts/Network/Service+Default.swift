//
//  Service+Default.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

extension Service {
    var baseURL: String {
        return "https://api.chucknorris.io"
    }
    
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/jokes" + path
        
        if method == .get {
            // add query items to url
            if let parameters = parameters as? [String: String] {
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
        }
        
        return urlComponents?.url
    }
}

extension ServiceExecutor {
    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void) {
        print("#########################")
        print(service.urlRequest)
        print("#########################")
        URLSession.shared.dataTask(with: service.urlRequest) { (data, _, error) in
            if let data = data {
                print((String(describing: String(data: data, encoding: .utf8))))
            }
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}

class Executor: ServiceExecutor {}

class MockFailureExecutor: ServiceExecutor {
    func execute<T: Service>(_ service: T, deliverQueue: DispatchQueue, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.failure(GenericError.generic))
    }
}

class MockExecutor: ServiceExecutor {
    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = Bundle.main.url(forResource: service.stub, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
