//
//  FactViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

class FactViewModel: Identifiable {
    let id = UUID()
    
    let fact: ChuckNorrisFact
    
    init(fact: ChuckNorrisFact) {
        self.fact = fact
    }
    
    var factDescription: String {
        return fact.value
    }
    
    var categories: [String] {
        return fact.categories.count > 0 ? fact.categories : ["UNCATEGORIZED"]
    }
}
