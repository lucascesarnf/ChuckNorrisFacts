//
//  ServiceExecutor.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

protocol ServiceExecutor: AnyObject {
    var saveData: Bool { get set }
    func execute<T: Service>(_ service: T, completion: @escaping (Result<Data, Error>) -> Void)
    func saveData(value: Data, url: String)
}
