//
//  ListCoordinator.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/25.
//

import UIKit

public final class ListCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start() {
        let repository = MainGitHubUserRepository()
        let usecase = GitHubUserService(repository: repository)
        let vm = ListViewModel(delegate: self, usecase: usecase)
        let vc = ListViewController(viewModel: vm)
        self.navigationController.pushViewController(vc, animated: false)
    }
}

extension ListCoordinator: ListViewModelDelegate {
    public func goToDetail(entity: RepoEntity) {
        let coordinator = DetailCoordinator(navigationController: self.navigationController, delegate: self, param: DetailCoordinator.Params(entity: entity))
        add(child: coordinator)
        coordinator.start()
    }
}

extension ListCoordinator: DetailCoordinatorDelegate {
    public func dismiss(_ coordinator: Coordinator) {
        remove(child: coordinator)
    }
}
