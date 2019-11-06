//
//  ServiceExecutor+Default.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

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
        _ = rxTest(service)
            .retry(.customTimerDelayed(maxCount: 3, delayCalculator: { retries -> DispatchTimeInterval in
                return DispatchTimeInterval.seconds(Int(retries * 4))
            }),
           shouldRetry: { error in
              print("⚠️ Retry ⚠️")
              return URLError.Code(rawValue: error¬¬.code) == .notConnectedToInternet
          })
            .subscribe(
                onNext: { data in
                    print(data)
                    completion(.success(data))
                },
                onError: { error in
                    print(error)
                    completion(.failure(error))
            })
    }

    @discardableResult
    func rxTest<T: Service>(_ service: T) -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            print("\n\n#########################")
            service.urlRequest.log()
            self.makeSessionWith(timeout: service.timeout).dataTask(with:
            service.urlRequest) { (data, response, error) in
                if let error = error {
                    print("⛔ Request failed")
                    observer.onError(error)
                    //completion(.failure(error))
                } else if let data = data {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200,
                        let statusError = self.statusCodeError(data: data) {
                        print("⛔ Request Error")
                        observer.onError(statusError)//completion(.failure(statusError))
                        return
                    }
                    print("✅ Request completed")
                    self.printJsonData(data: data)
                    if self.saveData {
                        self.saveData(value: data, url: service.urlString)
                    }
                    observer.onNext(data)
                }
            }.resume()
            return Disposables.create()
        }
    }

    func saveData(value: Data, url: String) {
        ServiceResultManager.saveData(value: value, url: url)
    }

    private func dispatchQueue() -> DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }

    private func makeSessionWith(timeout: Timeout) -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout.rawValue
        sessionConfig.timeoutIntervalForResource = timeout.rawValue
        return URLSession(configuration: sessionConfig)
    }

    private func statusCodeError(data: Data) -> Error? {
        let result = try? APIError.decode(from: data)
        return result?.error
    }
}
