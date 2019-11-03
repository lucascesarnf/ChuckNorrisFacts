//
//  FactViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

class FactViewModel: Identifiable, Equatable {
    // MARK: - @Combine
    @Published var fact: ChuckNorrisFact
    @Published var shareURL: Bool = false

    // MARK: - Variables/Constants
    let id = UUID()
    let textToShare = "ChuckNorris is awesome!  Check out this fact about him!"
    let emptyCategories = ["UNCATEGORIZED"]
    let caractersLimitNumber = 80
    var activityVC: ActivityView!

    // MARK: - Lifecycle
    init(_ fact: ChuckNorrisFact) {
        self.fact = fact
    }

    // MARK: - Functions
    func factDescription() -> String {
        return fact.value
    }

    func fontSize() -> CGFloat {
        return FontSize(numberOfCaracters: factDescription().count).rawValue
    }

    func categories() -> [String] {
        return fact.categories.count > 0 ? fact.categories : emptyCategories
    }

    func shareFact() {
        var objectsToShare: [Any] = [textToShare]
        if let url = fact.url, let rote = NSURL(string: url) {
            objectsToShare = [rote]
        }
        activityVC = ActivityView(activityItems: objectsToShare, applicationActivities: nil)
    }

    static func == (lhs: FactViewModel, rhs: FactViewModel) -> Bool {
           return lhs.fact == rhs.fact
    }
}
