//
//  UnwrapperOperator.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

/// I know that this useless but i like the power of change the Swift language :)
postfix operator ^^

postfix func ^^(rhs: String?) -> String {
    return rhs ?? ""
}

postfix func ^^(rhs: Int?) -> Int {
    return rhs ?? 0
}

postfix func ^^(rhs: Double?) -> Double {
    return rhs ?? 0
}

postfix func ^^(rhs: NSURL?) -> NSURL {
    return rhs ?? NSURL()
}

