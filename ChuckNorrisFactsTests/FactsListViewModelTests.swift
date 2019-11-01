//
//  FactsListViewModelTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest
@testable import ChuckNorrisFacts

class FactsListViewModelTests: XCTestCase {
    var viewModel: FactListViewModel!
    var dataManager: DataManager!

    override func setUp() {
        super.setUp()
        viewModel = FactListViewModel()
        viewModel.provider.executor = MockExecutor()
        dataManager = DataManager()
    }

    override func tearDown() {
        viewModel = nil
        dataManager.reset()
        dataManager = nil
        super.tearDown()
    }

    func testLoadCategories() {
        let service = ChuckNorrisFactsService.categories
        let expectation = self.expectation(description: "Load categories")
        self.measure {
            viewModel.provider.executeListner = { _ in
                let categories = self.dataManager.loadObject(url: service.urlString, decodeType: [String].self)
                XCTAssertNotNil(categories)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
