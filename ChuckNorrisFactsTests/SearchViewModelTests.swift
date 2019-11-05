//
//  SearchViewModelTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Lucas César  Nogueira Fonseca on 04/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest
import RxCocoa
@testable import ChuckNorrisFacts

class SearchViewModelTests: XCTestCase {
    // MARK: - Variables/Constants
    var viewModel: SearchFactViewModel!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        viewModel = SearchFactViewModel()
    }

    override func tearDown() {
        viewModel = nil
        ServiceResultManager.reset()
        SearchTermManager.reset()
        super.tearDown()
    }

    // MARK: - Tests
     func testNoCategories() {
        XCTAssertFalse(viewModel.haveCategories())
     }

    func testHaveCategories() {
        if let data = MockExecutor.getDataFromJson(jsonFile: "CategoriesData") {
            ServiceResultManager.saveData(value: data, url: ChuckNorrisFactsService.categories.urlString)
            XCTAssertTrue(viewModel.haveCategories())
        } else {
            XCTFail("Fail while try to parse CategoriesData json to Data")
        }
    }

    func testNumerOfLoadedCategories() {
        let numberOfLoadedCategories = 8
        if let data = MockExecutor.getDataFromJson(jsonFile: "CategoriesData") {
            ServiceResultManager.saveData(value: data, url: ChuckNorrisFactsService.categories.urlString)
            XCTAssertTrue(viewModel.haveCategories())
            let categories = viewModel.categoriesGrid.flatMap({$0})
            XCTAssertEqual(categories.count, numberOfLoadedCategories, "Number of loaded categories is wrong")
        } else {
            XCTFail("Fail while try to parse CategoriesData json to Data")
        }
    }

    func testSearchRepeatedTerm() {
        let terms = ["One", "Two", "Two", "Two", "Three", "Testing", "..."]
        for term in terms {
           viewModel.saveSearchTerm(term)
           mockCloseAndOpenViewModel()
        }
        XCTAssertEqual(viewModel.pastSearches, terms.uniques.reversed(), "SearchViewModel is saving repeated terms")
    }

    func testMostRecentTerm() {
        let terms = ["One", "Two", "Three", "Testing", "..."]
        for term in terms {
            viewModel.saveSearchTerm(term)
            mockCloseAndOpenViewModel()
        }

        viewModel.saveSearchTerm(terms[0])
        mockCloseAndOpenViewModel()
        XCTAssertEqual(viewModel.pastSearches.first†, terms[0], "SearchViewModel is not saving terms sorted by time")
    }

    func testLimitOfPastTerms() {
        let terms = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Testing", "..."]
        for term in terms {
           viewModel.saveSearchTerm(term)
           mockCloseAndOpenViewModel()
        }
        XCTAssertEqual(viewModel.pastSearches,
                       terms.dropFirst().reversed(), "SearchViewModel is saving more than limit terms")
    }

    private func mockCloseAndOpenViewModel() {
        ///ViewModelSearchTerm resets whenever you search and save a term
        viewModel = SearchFactViewModel()
    }
}
