//
//  ChuckNorrisFactsService.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

enum ChuckNorrisFactsService {
    case categories
    case query(_ query: String)
}

extension ChuckNorrisFactsService: Service {
    var path: String {
        switch self {
        case .categories:
            return "/categories"
        case .query:
            return "/search"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .query(let query):
            return ["query": query]
        default:
            break
        }
        return nil
    }

    var sampleData: String {
        switch self {
        case .query:
            return "FactsData"
        case .categories:
            return "CategoriesData"
        }
    }

    var method: ServiceMethod {
        return .get
    }

    var dataType: Codable.Type {
        switch self {
        case .query:
            return ChuckNorrisFactsResponse.self
        case .categories:
            return [String].self
        }
    }
}
