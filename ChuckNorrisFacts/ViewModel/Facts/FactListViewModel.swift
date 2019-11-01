//
//  FactListViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//





///Adicionar caso onde não há cache e há erro




import Foundation
import SwiftUI
import Combine
import UIKit

class FactListViewModel: ObservableObject {
    // MARK: - @Combine
    @Published var currentState = FactListState.noFacts
    @Published var didError = false
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
        didError = false
        performingQuery = true
        let cache = provider.load(service: .query(query), decodeType: ChuckNorrisFactsResponse.self) { result in
            switch result {
            case .success(let response):
                var facts = response.result.map(FactViewModel.init)
                facts.append(contentsOf: self.facts)
                self.facts = facts.uniques
                self.currentState = .facts
            case .failure(let error):
                print((error as NSError).code)
                print(error.localizedDescription)
                self.error = error
                self.didError = true
                self.removeToastAfterDelay()
            }
            self.performingQuery = false
        }

        if let facts = cache {
            self.facts = facts.result.map(FactViewModel.init)
            self.currentState = .facts
        } else {
            self.currentState = .load
        }
    }

    private func fetch(category: String) {
        didError = false
        performingCategory = true
        let cache = provider.load(service: .category(category), decodeType: ChuckNorrisFact.self) { result in
            switch result {
            case .success(let response):
                var facts = [response].map(FactViewModel.init)
                facts.append(contentsOf: self.facts)
                self.facts = facts.uniques
                self.currentState = .facts
            case .failure(let error):
                print((error as NSError).code)
                print(error.localizedDescription)
                self.error = error
                self.didError = true
                self.removeToastAfterDelay()
            }
            self.performingCategory = false
        }

        if let fact = cache {
            self.facts = [fact].map(FactViewModel.init)
            self.currentState = .facts
        } else {
            self.currentState = .load
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
}
