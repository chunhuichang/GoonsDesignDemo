//
//  DetailCoordinator.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/25.
//

import UIKit

public protocol DetailCoordinatorDelegate: AnyObject {
    func dismiss(_ coordinator: Coordinator)
}

public final class DetailCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    private weak var delegate: DetailCoordinatorDelegate?

    init(navigationController: UINavigationController, delegate: DetailCoordinatorDelegate?) {
        self.navigationController = navigationController
        self.delegate = delegate
    }

    public func start() {
        let vc = DetailViewController(delegate: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension DetailCoordinator: DetailViewControllerDelegate {
    public func dismiss() {
        self.delegate?.dismiss(self)
    }
}
