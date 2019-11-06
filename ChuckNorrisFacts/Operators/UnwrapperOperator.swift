//
//  UnwrapperOperator.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

/// I know that this useless but i like the power of change the Swift language :)
///❗ I don't use things like that in real projects 👍

///👹 This operator will exorcise all of optionals and purify them🙏
postfix operator †

postfix func † (rhs: String?) -> String {
    return rhs ?? ""
}

postfix func † (rhs: Date?) -> Date {
    return rhs ?? Date()
}

postfix func †<T>(rhs: [T]?) -> [T] {
    return rhs ?? []
}

postfix func † (rhs: Int?) -> Int {
    return rhs ?? 0
}

postfix func † (rhs: Bool?) -> Bool {
    return rhs ?? false
}

postfix func † (rhs: NSURL?) -> NSURL {
    return rhs ?? NSURL()
}

postfix func † (rhs: NSString?) -> NSString {
    return rhs ?? ""
}
