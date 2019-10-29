//
//  ChuckNorrisFactsService.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

enum ChuckNorrisFactsService {
    case random
    case categories
    case category(_ category: String)
    case query(_ query: String)
}

extension ChuckNorrisFactsService: Service {
    
    var path: String {
        switch self {
        case .random, .category(_):
            return "/random"
        case .categories:
            return "/categories"
        case .query(_):
            return "/search"
        }
    }
    
    var parameters: [String: Any]? {
        
        switch self {
        case .category(let category):
            return ["category": category]
        case .query(let query):
            return ["query": query]
        default:
            break
        }
        return nil
    }
    
    var sampleData: String {
        switch self {
        case .category(_), .random:
            return "RandonFactData"
        case .query(_):
            return "FactsData"
        case .categories:
            return "CategoriesData"
        }
    }
    
    
    var method: ServiceMethod {
        return .get
    }
}
