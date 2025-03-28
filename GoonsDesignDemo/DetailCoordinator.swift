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
    public struct Params {
        let entity: RepoEntity
    }

    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    private weak var delegate: DetailCoordinatorDelegate?
    private let param: Params

    init(navigationController: UINavigationController, delegate: DetailCoordinatorDelegate?, param: Params) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.param = param
    }

    public func start() {
        let entity = self.param.entity
        let vm = DetailViewModel(entity: entity)
        let vc = DetailViewController(delegate: self, viewModel: vm)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension DetailCoordinator: DetailViewControllerDelegate {
    public func dismiss() {
        self.delegate?.dismiss(self)
    }
}
