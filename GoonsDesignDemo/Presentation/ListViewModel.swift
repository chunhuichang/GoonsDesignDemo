//
//  ListViewModel.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/28.
//

import Foundation

class ListViewModel: ObservableObject {
    // Output
    @Published private(set) var repos: [RepoEntity] = []
    @Published private(set) var errorInput: Bool = false
    
    private weak var delegate: ListViewModelDelegate?
    private let service: GitHubUserServiceProtocol

    init(delegate: ListViewModelDelegate?, service: GitHubUserServiceProtocol) {
        self.delegate = delegate
        self.service = service
    }

    // Input
    func search(_ key: String?) {
        guard let key, !key.isEmpty else {
            errorInput = true
            return
        }
        Task {
            let result = await service.fetchRepos(queryText: key)

            switch result {
            case .success(let items):
                await MainActor.run {
                    repos = items
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }

    func clear() {
        repos = []
    }

    func didSelectRowAt(_ index: Int) {
        delegate?.goToDetail(entity: repos[index])
    }
}

public protocol ListViewModelDelegate: AnyObject {
    func goToDetail(entity: RepoEntity)
}
