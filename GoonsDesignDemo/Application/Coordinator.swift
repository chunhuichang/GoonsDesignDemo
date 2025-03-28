//
//  Coordinator.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/25.
//

import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

public extension Coordinator {
    func add(child: Coordinator) {
        childCoordinators.append(child)
    }

    func remove(child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
}
