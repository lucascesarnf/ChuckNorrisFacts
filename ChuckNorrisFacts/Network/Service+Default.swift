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
            if let parameters = parameters as? [String: String] {
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
        }
        return urlComponents?.url
    }
}

extension ServiceExecutor {

    func printJsonData(data: Data) {
        do {
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
                let result = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                if let result = result, let dataString = String(data: result, encoding: .utf8) {
                    print(dataString)
                }
            }
        }
    }

    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void) {

        print("\n\n#########################")
        service.urlRequest.log()
        URLSession.shared.dataTask(with: service.urlRequest) { (data, _, error) in
            if let error = error {
                print("⛔ Request failed")
                completion(.failure(error))
            } else if let data = data {
                print("✅ Request completed")
                self.printJsonData(data: data)
                self.saveData(key: service.sampleData, value: data, url: service.urlRequest.url)
                completion(.success(data))
            }
        }.resume()
    }

    private func saveData(key: String, value: Data, url: URL?) {
        var dataManager = DataManager()
        if let url = url {
            dataManager.saveData(key: key, value: value, url: String(describing: url))
        }
    }
}

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
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}
