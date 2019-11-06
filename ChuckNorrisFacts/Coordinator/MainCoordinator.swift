//
//  MainCoordinator.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 05/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var factsListViewController: UIViewController?
    var factsListViewModel: FactsListViewModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        if ProcessInfo.processInfo.arguments.contains("ClearCoreData") {
            ServiceResultManager.reset()
            SearchTermManager.reset()
        }
    }

    func start() {
      navigationController.pushViewController(buildFactsList(), animated: false)
    }

    func buildFactsList() -> UIViewController {
        let viewModel = FactsListViewModel()
             let view = FactsListView(viewModel: viewModel, navigationController: navigationController)
             let viewController = UIHostingController(rootView: view)
             factsListViewModel = viewModel
             factsListViewController = viewController
        return viewController
    }
}
