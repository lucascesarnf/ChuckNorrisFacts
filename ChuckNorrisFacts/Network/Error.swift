//
//  Error.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
enum GenericError: Error {
    case generic
    case netWork
}

extension GenericError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic:
            return "A generic error was forced to happen"
        case .netWork:
            return "There is no internet connection"
        }
    }
}
