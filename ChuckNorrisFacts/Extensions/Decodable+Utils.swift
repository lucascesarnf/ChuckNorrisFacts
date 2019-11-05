//
//  Decodable+Utils.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 04/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
