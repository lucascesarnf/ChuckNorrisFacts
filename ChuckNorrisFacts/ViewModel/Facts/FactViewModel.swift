//
//  FactViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

class FactViewModel: Identifiable {
    
    @Published var fact: ChuckNorrisFact
    @Published var shareURL: Bool = false
    
    let id = UUID()
    let textToShare = "ChuckNorris is awesome!  Check out this fact about him!"
    var activityVC: ActivityView!
    
    init(fact: ChuckNorrisFact) {
        self.fact = fact
    }
    
    var factDescription: String {
        return fact.value
    }
    
    var categories: [String] {
        return fact.categories.count > 0 ? fact.categories : ["UNCATEGORIZED"]
    }
    
    func shareFact() {
        var objectsToShare: [Any] = [textToShare]
        if let url = fact.url, let rote = NSURL(string: url) {
            objectsToShare = [rote]
        }
        activityVC = ActivityView(activityItems: objectsToShare, applicationActivities: nil)
    }
}
