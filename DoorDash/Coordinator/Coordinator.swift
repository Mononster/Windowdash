//
//  Coordinator.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-06.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class, Presentable {
    var coordinators: [Coordinator] { get set }
    var router: Router { get }
}

extension Coordinator {

    func addCoordinator(_ coordinator: Coordinator) {
        coordinators.append(coordinator)
    }

    func removeCoordinator(_ coordinator: Coordinator?) {
        guard let coordinator = coordinator else {
            return
        }
        coordinators = coordinators.filter { $0 !== coordinator }
    }

    func removeAllCoordinators() {
        coordinators.removeAll()
    }
}
