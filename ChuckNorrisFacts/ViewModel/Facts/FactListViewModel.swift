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

class FactListViewModel: ObservableObject {
    let provider = ServiceProvider<ChuckNorrisFactsService>(executor: MockExecutor())
    let responseFacts = PassthroughSubject<FactListViewModel, Never>()
    
    init() {
        fetchRandom()
    }
    
    var facts = [FactViewModel]() {
        didSet {
            responseFacts.send(self)
        }
    }
    
    private func fetchRandom() {
        provider.load(service: .random, decodeType: ChuckNorrisFactsResponse.self) { result in
            switch result {
            case .success(let response):
                self.facts = response.result.map(FactViewModel.init)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
