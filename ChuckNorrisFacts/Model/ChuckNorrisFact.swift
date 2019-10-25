//
//  ChuckNorrisFact.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

struct ChuckNorrisFactsResponse: Codable, Hashable {
    var total: Int
    var result: [ChuckNorrisFact]
}

struct ChuckNorrisFact: Codable, Hashable {
    var iconURL: String?
    var id: String?
    var url: String?
    var value: String
    var categories: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case iconURL = "icon_url"
        case id, url, value, categories
    }
}


