//
//  ServiceExecutor+Default.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

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
        makeSessionWith(timeout: service.timeout).dataTask(with: service.urlRequest) { (data, response, error) in
            if let error = error {
                print("⛔ Request failed")
                completion(.failure(error))
            } else if let data = data {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200,
                    let statusError = self.statusCodeError(data: data) {
                    print("⛔ Request Error")
                    completion(.failure(statusError))
                    return
                }
                print("✅ Request completed")
                self.printJsonData(data: data)
                if service.saveData {
                    self.saveData(value: data, url: "\(service.urlRequest)")
                }
                completion(.success(data))
            }
        }.resume()
    }

    func saveData(value: Data, url: String) {
        ServiceResultManager.saveData(value: value, url: url)
    }

    private func makeSessionWith(timeout: Timeout) -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout.rawValue
        sessionConfig.timeoutIntervalForResource = timeout.rawValue
        return URLSession(configuration: sessionConfig)
    }

    private func statusCodeError(data: Data) -> Error? {
        let decoder = JSONDecoder()
        let result = try? decoder.decode(APIError.self, from: data)
        return result?.error
    }
}
