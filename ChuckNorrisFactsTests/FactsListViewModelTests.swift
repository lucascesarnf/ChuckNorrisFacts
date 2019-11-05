//
//  FactsListViewModelTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Lucas César  Nogueira Fonseca on 30/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest
import Combine
@testable import ChuckNorrisFacts

class FactsListViewModelTests: XCTestCase {

    // MARK: - Variables/Constants
    var viewModel: FactsListViewModel!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        viewModel = FactsListViewModel(provider: ServiceProvider<ChuckNorrisFactsService>(executor: MockExecutor()))
    }

    override func tearDown() {
        viewModel = nil
        ServiceResultManager.reset()
        super.tearDown()
    }

    // MARK: - Tests
    func testLoadCategories() {
        let service = ChuckNorrisFactsService.categories
        let expectation = self.expectation(description: "Load categories success")
        //Reinitialization to observate listner changes
        viewModel = FactsListViewModel(provider: ServiceProvider<ChuckNorrisFactsService>(executor: MockExecutor()))
        viewModel.provider?.listner = { result in
            XCTAssertNotNil(result)
            let categories = ServiceResultManager.loadObject(url: service.urlString, decodeType: [String].self)
            XCTAssertNotNil(categories)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchFactsSuccess() {
        if let expectedFacs = expectedFacsData(from: "FactsData", decodeType: ChuckNorrisFactsResponse.self) {
            let expectation = self.expectation(description: "Load Facts Success")
            viewModel.performQuery(PerformQuery.query(""))

            let sink = viewModel.$currentState.sink(receiveValue: { factListState in
                switch factListState {
                case .facts:
                    XCTAssertEqual(self.viewModel.facts,
                                   expectedFacs.result.uniques, "Viewmodel parcer and compute facts is wrong")
                    expectation.fulfill()
                default: break
                }
            })
            XCTAssertNotNil(sink)
            waitForExpectations(timeout: 5, handler: nil)
        } else {
            XCTFail("Fail while try to parse FacsData json to ChuckNorrisFactsResponse")
        }
    }

    func testFetchFactsZeroResultsSuccess() {
        let expectation = self.expectation(description: "Load Facts Zero Results Success")
        let executor = MockExecutor(jsonInjection: "FactsDataZeroResults")
        viewModel.provider?.executor = executor
        viewModel.performQuery(PerformQuery.query(""))

        let sink = viewModel.$currentState.sink(receiveValue: { factListState in
            switch factListState {
            case .noCasheAndError:
                XCTAssertEqual(self.viewModel.error,
                               FactsError.noFacts, "Viewmodel no results response with no cache is wrong")
                expectation.fulfill()
            default: break
            }
        })
        XCTAssertNotNil(sink)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchFactsFailureWithoutCache() {
        let expectation = self.expectation(description: "Failed to load facts without cache")
        let executor = MockFailureExecutor()
        viewModel.provider?.executor = executor
        viewModel.performQuery(PerformQuery.query(""))

        let sink = viewModel.$currentState.sink(receiveValue: { factListState in
            switch factListState {
            case .noCasheAndError:
                XCTAssertEqual(self.viewModel.error,
                               FactsError.generic, "Viewmodel error with no cache is wrong")
                expectation.fulfill()
            default: break
            }
        })
        XCTAssertNotNil(sink)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSetErrorObservable() {
        viewModel.setError(true)
        let sink = viewModel.$didError.sink(receiveValue: { didError in
            XCTAssertTrue(didError)
        })
        XCTAssertNotNil(sink)
    }

    func testLocalRandonLocalFacts() {
        let expectation = self.expectation(description: "Failed to load local facts")
        if let data = MockExecutor.getDataFromJson(jsonFile: "FactsData") {
            ServiceResultManager.saveData(value: data, url: "test/facts/")
            ServiceResultManager.saveContext()
            let sink = viewModel.$currentState.sink(receiveValue: { factListState in
                switch factListState {
                case .facts:
                    XCTAssertNotNil(self.viewModel.localFacts,
                                   "Viewmodel load local facts fail to bring randon facts")
                    expectation.fulfill()
                default:
                    break
                }
            })
            XCTAssertNotNil(sink)
            viewModel.loadLocalFacts()
            waitForExpectations(timeout: 5, handler: nil)
        } else {
            XCTFail("Fail while try to parse FactsData json to Data")
        }
    }

    func testRequestErrorAndLoadCache() {
        if let data = MockExecutor.getDataFromJson(jsonFile: "FactsData") {
            let expectation = self.expectation(description: "Failed to load cache when service returns error")
            let url = ChuckNorrisFactsService.query("test").urlString
            ServiceResultManager.saveData(value: data, url: url)
            let sink = viewModel.$didError.sink(receiveValue: { didError in
                if didError {
                    XCTAssertNotNil(self.viewModel.facts,
                                    "Viewmodel load local facts fail to bring randon facts")
                    expectation.fulfill()
                }
            })
            XCTAssertNotNil(sink)
            let executor = MockFailureExecutor()
            viewModel.provider?.executor = executor
            viewModel.performQuery(PerformQuery.query("test"))
            waitForExpectations(timeout: 5, handler: nil)
        } else {
            XCTFail("Fail while try to parse FactsData json to Data")
        }
    }

    private func expectedFacsData<U>(from json: String, decodeType: U.Type) -> U? where U: Decodable {
        guard let expectedData = MockExecutor.getDataFromJson(jsonFile: json),
            let expected = try? decodeType.decode(from: expectedData) else { return nil }
        return expected
    }
}
