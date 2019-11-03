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

    // MARK: - Lifecycle
    init() {
        loadPastSearch()
    }

    // MARK: - Functions
    func theareCategories() -> Bool {
        loadCategories()
        return categories.count > 0
    }

    func saveSearchTerm(_ term: String) {
        if !term.isEmpty && term.count > 3 && !pastSearches.contains(term) {
            SearchTermManager.saveData(term: term)
        }
    }

    private func loadPastSearch() {
        pastSearches = SearchTermManager.loadData()
    }

    private func loadCategories() {
        if categories.isEmpty {
            self.categories = ServiceResultManager.loadObject(url: ChuckNorrisFactsService.categories.urlString,
                decodeType: [String].self)†.choose(numberOfCategories)
            makeCategoriesGrid()
        }
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
