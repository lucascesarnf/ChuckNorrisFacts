//
//  OperatorsTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Lucas César  Nogueira Fonseca on 06/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest
@testable import ChuckNorrisFacts

class OperatorsTests: XCTestCase {

    func testStringUnwrapperOperator() {
        let nilString: String? = nil
        let string: String? = "Teste"
        XCTAssertNil(nilString)
        XCTAssertNotNil(nilString†)
        XCTAssertNotNil(string†)
    }

    func testDateUnwrapperOperator() {
        let nilDate: Date? = nil
        let date: Date? = Date()
        XCTAssertNil(nilDate)
        XCTAssertNotNil(nilDate†)
        XCTAssertNotNil(date†)
    }

    func testArrayUnwrapperOperator() {
        let nilArray: [String]? = nil
        let array: [String]? = ["Teste"]
        XCTAssertNil(nilArray)
        XCTAssertNotNil(nilArray†)
        XCTAssertNotNil(array†)
    }

    func testIntUnwrapperOperator() {
        let nilInt: Int? = nil
        let value: Int? = 0
        XCTAssertNil(nilInt)
        XCTAssertNotNil(nilInt†)
        XCTAssertNotNil(value†)
    }

    func testBoolUnwrapperOperator() {
        let nilBool: Bool? = nil
        let bool: Bool? = true
        XCTAssertNil(nilBool)
        XCTAssertNotNil(nilBool†)
        XCTAssertNotNil(bool†)
    }

    func testURLUnwrapperOperator() {
        let nilURL: NSURL? = nil
        let url: NSURL? = NSURL()
        XCTAssertNil(nilURL)
        XCTAssertNotNil(nilURL†)
        XCTAssertNotNil(url†)
    }

    func testNSStringUnwrapperOperator() {
        let nilString: NSString? = nil
        let string: NSString? = "Teste"
        XCTAssertNil(nilString)
        XCTAssertNotNil(nilString†)
        XCTAssertNotNil(string†)
    }
}
