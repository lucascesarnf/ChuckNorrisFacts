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
    var facts = [ChuckNorrisFact]()
    var localFacts = [ChuckNorrisFact]()
    var error = FactsError.generic
    let provider = ServiceProvider<ChuckNorrisFactsService>()
    let numberOfLocalFacts = 10

    // MARK: - Lifecycle
    init() {
        loadCategories()
        loadLocalFacts()
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
                self.successHandling(response.result)
            case .failure(let error):
                self.errorHandling(error)
            }
            self.performingQuery = false
        }

        if let facts = cache?.result, (cache?.total)† > 0 {
            cacheHandling(facts)
        } else {
            loaderHandling()
        }
    }

    func performQuery(_ type: PerformQuery) {
        switch type {
        case .query(let query):
            if !performingQuery {
                fetch(query: query)
            }
        default: break
        }
    }

    private func cleanStatus() {
        didError = false
        didCache = false
    }

    private func loadLocalFacts() {
        let results = ServiceResultManager.loadRandonObjects(decodeType: ChuckNorrisFactsResponse.self)
        localFacts = results.flatMap({$0.result}).choose(numberOfLocalFacts)
        if !localFacts.isEmpty {
            currentState = .facts
        }
    }

   // MARK: - Handling
    private func loaderHandling() {
        self.facts = []
        self.currentState = .load
    }

    private func cacheHandling(_ cache: [ChuckNorrisFact]) {
        facts = cache
        didCache = true
        currentState = .facts
    }

    private func successHandling(_ facts: [ChuckNorrisFact]) {
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
