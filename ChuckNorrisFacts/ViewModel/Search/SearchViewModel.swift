//
//  SearchViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 26/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    // MARK: - @Combine
    @Published var shouldShowSearchScreen: Bool = false

    // MARK: - Variables/Constants
    var categoriesGrid = [[String]]()
    var pastSearches = [String]()
    private var categories = [String]()
    private let numberOfCategories = 8
    private let categoriesColumnsNumer = 3
    private let limitOfSearchTerms = 8
    private let minimumNumberOfCharacters = 3

    // MARK: - Lifecycle
    init() {
        loadPastSearch()
    }

    // MARK: - Functions
    func haveCategories() -> Bool {
        loadCategories()
        return categories.count > 0
    }

    func saveSearchTerm(_ term: String) {
        if !term.isEmpty && term.count >= 3 && !pastSearches.contains(term) {
            if pastSearches.count < limitOfSearchTerms {
                SearchTermManager.saveObject(term: term, time: Date())
            } else {
                deleteLastAndSaveNew(term: term)
            }
        } else if pastSearches.contains(term) {
            SearchTermManager.updateObject(term: term, time: Date())
        }
    }

    private func loadPastSearch() {
        pastSearches = SearchTermManager.loadObject()
    }

    private func loadCategories() {
        if categories.isEmpty {
            self.categories = ServiceResultManager.loadObject(url: ChuckNorrisFactsService.categories.urlString,
                decodeType: [String].self)†.choose(numberOfCategories)
            makeCategoriesGrid()
        }
    }

    private func deleteLastAndSaveNew(term: String) {
        let serviceToRemoveCache = ChuckNorrisFactsService.query(term)
        SearchTermManager.removeObject(term: pastSearches.last†)
        ServiceResultManager.removeObject(url: serviceToRemoveCache.urlString)
        SearchTermManager.saveObject(term: term, time: Date())
    }

    private func makeCategoriesGrid() {
        var grid = [[String]]()
        var count = 0

        for line in 0..<categoriesColumnsNumer {
            var array = [String]()
            for column in 0..<categoriesColumnsNumer {
                count = line * categoriesColumnsNumer + column
                if categories.indices.contains(count) {
                    array.append(categories[count])
                }
                count += 1
            }
            if array.count > 0 {
                grid.append(array)
            }
        }
        categoriesGrid = grid
    }
}
