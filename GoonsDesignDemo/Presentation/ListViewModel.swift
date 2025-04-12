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
    private let usecase: GitHubUserUseCase
    private var searchText: String? = nil

    init(delegate: ListViewModelDelegate?, usecase: GitHubUserUseCase) {
        self.delegate = delegate
        self.usecase = usecase
    }

    // Input
    func search(_ key: String?) {
        searchText = key
        guard let key, !key.isEmpty else {
            errorInput = true
            return
        }
        Task {
            let result = await usecase.fetchRepos(queryText: key)

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

    func refreshList() {
        search(searchText)
    }

    func clear() {
        searchText = nil
        repos = []
    }

    func didSelectRowAt(_ index: Int) {
        delegate?.goToDetail(entity: repos[index])
    }
    
    func getImageRepository() -> ImageRepository {
        usecase.getImageRepository()
    }
}

public protocol ListViewModelDelegate: AnyObject {
    func goToDetail(entity: RepoEntity)
}
