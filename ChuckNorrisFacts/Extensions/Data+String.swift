//
//  Data+String.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 29/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation

extension Data {
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
