//
//  FactViewModelTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Lucas César  Nogueira Fonseca on 21/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest
@testable import ChuckNorrisFacts

class FactViewModelTests: XCTestCase {
    var viewModel: FactViewModel!
    let value = "Beaver's use there tails to build Dams." +
    " Chuck Norris once used his penis to build one. It's known as The Hoover Dam."
    let categories: [String] = []
    let url = "https://api.chucknorris.io/jokes/NpyqYKUbQmqgaPKahsSuHg"

    override func setUp() {
        super.setUp()
        let fact = ChuckNorrisFact(iconURL: nil,
                                   id: nil,
                                   url: url,
                                   value: value,
                                   categories: categories)
        viewModel = FactViewModel(fact: fact)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFontSize() {
        let fontSize = FontSize.init(numberOfCaracters: value.count)
        XCTAssertEqual(fontSize, FontSize.small, "Font size enum is wrong")
        XCTAssertEqual(fontSize.rawValue, viewModel.fontSize(), "View Model font size is wrong")
        XCTAssertEqual(viewModel.factDescription(), value, "Fact computed is wrong")
    }

    func testFactDescription() {
        XCTAssertEqual(viewModel.factDescription(), value, "Fact computed is wrong")
    }

    func testUncategorizedCategorie() {
        viewModel.fact.categories = []
        XCTAssertEqual(viewModel.categories(), ["UNCATEGORIZED"], "Category empy computed is wrong")
    }

    func testShareActivityView() {
        viewModel.activityVC = nil
        viewModel.shareFact()
        XCTAssertNotNil(viewModel.activityVC)
    }

}
