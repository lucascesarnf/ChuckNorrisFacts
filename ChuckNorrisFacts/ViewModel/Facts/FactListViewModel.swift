//
//  FactListViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit

class FactListViewModel: ObservableObject {
    let provider = ServiceProvider<ChuckNorrisFactsService>(executor: MockExecutor())
    
    init() {
        fetchRandom()
    }
    
    @Published var facts = [FactViewModel]()
    
    private func fetchRandom() {
        provider.load(service: .query(""), decodeType: ChuckNorrisFactsResponse.self) { result in
            switch result {
            case .success(let response):
                self.facts = response.result.map(FactViewModel.init)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
