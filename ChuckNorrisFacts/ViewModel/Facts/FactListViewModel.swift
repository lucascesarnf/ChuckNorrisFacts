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

    // MARK: - State Controll
    private var didCache = false
    private var lastQuery = ""
    private var performingCategory = false
    private var performingQuery = false

    // MARK: - Variables/Constants
    var facts = [FactViewModel]()
    var error = FactsError.generic

    // MARK: - Variables/Constants
    let provider = ServiceProvider<ChuckNorrisFactsService>()
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

    private func fetch(query: String) {
        cleanStatus()
        performingQuery = true
        let cache = provider.load(service: .query(query), decodeType: ChuckNorrisFactsResponse.self) { result in
            switch result {
            case .success(let response):
                self.successHandling(response.result.map(FactViewModel.init))
            case .failure(let error):
                self.errorHandling(error)
            }
            self.performingQuery = false
        }

        if let facts = cache {
            cacheHandling(facts.result.map(FactViewModel.init))
        } else {
            loaderHandling()
        }
    }

    private func fetch(category: String) {
        cleanStatus()
        performingCategory = true
        let cache = provider.load(service: .category(category), decodeType: ChuckNorrisFact.self) { result in
            switch result {
            case .success(let response):
                self.successHandling([response].map(FactViewModel.init))
            case .failure(let error):
                self.errorHandling(error)
            }
            self.performingCategory = false
        }

        if let fact = cache {
            cacheHandling([fact].map(FactViewModel.init))
        } else {
            loaderHandling()
        }
    }

    func performQuery(_ type: QueryType) {
        switch type {
        case .query(let query):
            if !performingQuery {
                fetch(query: query)
            }
        case .category(let category):
            if !performingCategory {
                fetch(category: category)
            }
        default: break
        }
    }

    private func cleanStatus() {
        didError = false
        didCache = false
    }

   // MARK: - Handling
    private func loaderHandling() {
        self.facts = []
        self.currentState = .load
    }

    private func cacheHandling(_ cache: [FactViewModel]) {
        facts = cache
        didCache = true
        currentState = .facts
    }

    private func successHandling(_ facts: [FactViewModel]) {
        if self.facts.isEmpty && facts.isEmpty {
            currentState = .noCasheAndError
            error = FactsError.noFacts
        } else {
            var mutable = facts
            mutable.append(contentsOf: self.facts)
            self.facts = mutable.uniques
            currentState = .facts
        }
    }

    private func errorHandling(_ error: FactsError) {
        print(error¬¬.code)
        print(error.localizedDescription)
        self.error = error
        removeToastAfterDelay()
        if didCache {
            didError = true
        } else {
            currentState = .noCasheAndError
        }
    }
}
