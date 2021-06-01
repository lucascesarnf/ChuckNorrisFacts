//
//  ExpectationHelpable.swift
//  ChuckNorrisFactsUITests
//
//  Created by Lucas Cesar Nogueira Fonseca on 20/05/21.
//  Copyright © 2021 Lucas César  Nogueira Fonseca. All rights reserved.
//

import XCTest

protocol ExpectationHelpable { }

extension ExpectationHelpable where Self: XCTestCase {
    func waitForExistence(of element: XCUIElement, file: String = #file, line: UInt = #line) {
        let idleTime: TimeInterval = 10
        let exists = NSPredicate(format: "exists == true")

        expectation(for: exists, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: idleTime) { error in
            if error != nil {
                let message = "Failed to find \(element) after \(idleTime) seconds."
                self.record(XCTIssue(type: .assertionFailure, compactDescription: message))
            }
        }
    }
}
