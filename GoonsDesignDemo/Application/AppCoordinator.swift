//
//  AppCoordinator.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/25.
//

import UIKit

public final class AppCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        let coordinator = ListCoordinator(navigationController: self.navigationController)
        add(child: coordinator)
        coordinator.start()
    }
}
