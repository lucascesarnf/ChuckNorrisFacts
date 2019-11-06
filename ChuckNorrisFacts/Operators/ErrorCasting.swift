//
//  ErrorCasting.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 29/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

/// I know that this useless but i like the power of change the Swift language :)
///❗ I don't use things like that in real projects 👍
postfix operator ¬¬

postfix func ¬¬ (rhs: Error) -> NSError {
    return (rhs as NSError)
}
