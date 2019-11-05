//
//  Coordinator.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 05/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
