//
//  SearchViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 26/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel: ObservableObject {
    // MARK: - @Combine
    @Published var text: String = ""
    @Published var shouldShowSearchScreen: Bool = false
}
