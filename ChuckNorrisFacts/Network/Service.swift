//
//  Service.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

enum ServiceMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Stubs {
    case stub(fileName: String)
    case fail
}

protocol Service {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: ServiceMethod { get }
    var sampleData: String { get }
}

protocol ServiceExecutor: AnyObject {
    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void)
}
