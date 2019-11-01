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
        URLSession.shared.dataTask(with: service.urlRequest) { (data, _, error) in
            if let error = error {
                print("⛔ Request failed")
                completion(.failure(error))
            } else if let data = data {
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
        let dataManager = DataManager()
        dataManager.saveData(value: value, url: url)
    }
}
