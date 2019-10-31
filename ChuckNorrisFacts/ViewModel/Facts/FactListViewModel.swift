//
//  FactListViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit

class FactListViewModel: ObservableObject {
    // MARK: - @Combine
    @Published var currentState = FactListState.noFacts
    @Published var didError = false

    // MARK: - Variables/Constants
    var facts = [FactViewModel]()
    var error = FactsError.generic

    // MARK: - Variables/Constants
    let provider = ServiceProvider<ChuckNorrisFactsService>(executor: Executor())
    var dataManager = DataManager()

    // MARK: - Lifecycle
    init() {
        loadCategories()
    }

    // MARK: - Functions
    func loadCategories() {
           provider.execute(service: .categories)
    }

    func removeToastAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.didError = false
        }
    }

//    private func fetch() {
//        didError = false
//        let cache = provider.load(service: .query("tatoo"), decodeType: ChuckNorrisFactsResponse.self) { result in
//            switch result {
//            case .success(let response):
//                self.facts = response.result.map(FactViewModel.init)
//                self.currentState = .facts
//            case .failure(let error):
//                print((error as NSError).code)
//                print(error.localizedDescription)
//                self.error = error
//                self.didError = true
//                self.removeToastAfterDelay()
//            }
//        }
//
//        if let facts = cache {
//            self.facts = facts.result.map(FactViewModel.init)
//            self.currentState = .facts
//        }
//    }
}
