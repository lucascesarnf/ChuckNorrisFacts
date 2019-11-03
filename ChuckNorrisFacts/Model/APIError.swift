//
//  APIError.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 03/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

struct APIError: LocalizedError, Codable, Hashable {
    var status: Int
    var errorDescription: String

    enum CodingKeys: String, CodingKey {
        case errorDescription = "message"
        case status
    }

    var error: Error {
         return NSError(domain: "", code: status, userInfo: [ NSLocalizedDescriptionKey: errorDescription]) as Error
    }
}
