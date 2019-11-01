//
//  SearchViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 26/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel: ObservableObject {
    // MARK: - @Combine
    @Published var shouldShowSearchScreen: Bool = false

    var categoriesGrid = [[String]]()
    private var categories = [String]()
    private var dataManager = DataManager()

    func theareCategories() -> Bool {
        loadCategories()
        return categories.count > 0
    }

    private func loadCategories() {
        if categories.count == 0 {
            self.categories = dataManager.loadObject(url: ChuckNorrisFactsService.categories.urlString,
                                                     decodeType: [String].self)†
            makeCategoriesGrid()
        }
    }

    private func makeCategoriesGrid() {
        let columnsNumer = 3
        var grid = [[String]]()
        var count = 0

        for line in 0..<columnsNumer {
            var array = [String]()
            for column in 0..<columnsNumer {
                count = line * columnsNumer + column
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
