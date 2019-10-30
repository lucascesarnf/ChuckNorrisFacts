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
    let provider = ServiceProvider<ChuckNorrisFactsService>(executor: Executor())
    var dataManager = DataManager()

    init() {
        fetchRandom()
    }

    @Published var facts = [FactViewModel]()

    private func fetchRandom() {
        let cache = provider.load(service: .query("tatoo"), decodeType: ChuckNorrisFactsResponse.self) { result in
            switch result {
            case .success(let response):
                self.facts = response.result.map(FactViewModel.init)
            case .failure(let error):
                print((error as NSError).code)
                print(error.localizedDescription)
            }
        }

        if let facts = cache {
            self.facts = facts.result.map(FactViewModel.init)
        }
    }
}
