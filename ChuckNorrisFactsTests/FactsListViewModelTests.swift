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

    override func setUp() {
        super.setUp()
        viewModel = FactListViewModel()
        viewModel.provider.executor = MockExecutor()
    }

    override func tearDown() {
        viewModel = nil
        ServiceResultManager.reset()
        super.tearDown()
    }

    func testLoadCategories() {
        let service = ChuckNorrisFactsService.categories
        let expectation = self.expectation(description: "Load categories")
        self.measure {
            viewModel.provider.executeListner = { _ in
                let categories = ServiceResultManager.loadObject(url: service.urlString, decodeType: [String].self)
                XCTAssertNotNil(categories)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
