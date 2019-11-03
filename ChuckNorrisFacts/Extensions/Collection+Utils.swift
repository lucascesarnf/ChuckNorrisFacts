//
//  Array+Utils.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 01/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
public extension Array where Element: Equatable {
    var uniques: [Element] {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

public extension Collection {
    func choose(_ n: Int) -> [Element] { Array(shuffled().prefix(n)) }
}
