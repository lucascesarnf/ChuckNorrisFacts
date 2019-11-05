//
//  FontSize.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 28/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
      case normal = 18
      case small = 16

    init(numberOfCaracters: Int) {
        self = numberOfCaracters > 80 ? FontSize.small : FontSize.normal
    }
}
