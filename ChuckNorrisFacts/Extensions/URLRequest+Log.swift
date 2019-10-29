//
//  URLRequest+Log.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 29/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

extension URLRequest {
    func log() {
        print("\(httpMethod ?? "") \(self)")
        print("BODY \n \(String(describing: httpBody?.toString()))")
        print("HEADERS \n \(String(describing: allHTTPHeaderFields))")
    }
}
