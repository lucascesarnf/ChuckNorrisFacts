//
//  ThreadSafetyCounter.swift
//  ChuckNorrisFactsUITests
//
//  Created by Lucas Cesar Nogueira Fonseca on 20/05/21.
//  Copyright © 2021 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

public struct SafetyCounter {
    private let queue = DispatchQueue(label: "queue.operations", attributes: .concurrent)
    private var counter = 0

    mutating func count() {
        queue.sync(flags: .barrier) {
            self.counter += 1
        }
    }

    var value: Int {
        queue.sync {
            self.counter
        }
    }
}
