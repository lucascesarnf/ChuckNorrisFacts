//
//  Error.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
enum FactsError: Error {
    case generic
    case notConnectedToInternet
    case networkConnectionLost
    case timeOut
    case returned(error: Error)

    init(error: Error) {
        switch URLError.Code(rawValue: error¬¬.code) {
        case .notConnectedToInternet:
            self = .notConnectedToInternet
        case .networkConnectionLost:
            self = .networkConnectionLost
        case .timedOut:
            self = .timeOut
        default:
            self = .returned(error: error)
        }
    }
}

extension FactsError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic:
            return "An unexpected error occurred, please try again later."
        case .notConnectedToInternet:
            return "There is no internet connection, check your network connection and try again."
        case .networkConnectionLost:
            return " The network connection was lost, check your network connection and try again."
        case .timeOut:
            return "Looks like the server is taking to long to respond, please try again later."
        case .returned(let error):
            return error.localizedDescription
        }
    }
}
