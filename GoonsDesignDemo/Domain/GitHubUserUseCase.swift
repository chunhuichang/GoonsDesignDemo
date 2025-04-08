//
//  GitHubUserService.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/27.
//

import Foundation

enum ServiceError: Error {
    case badURL
    case invalidResponse
}

protocol GitHubUserUseCase {
    func fetchRepos(queryText: String) async -> Result<[RepoEntity], Error>
}

struct GitHubUserService: GitHubUserUseCase {
    private let repository: GitHubUserRepository

    public init(repository: GitHubUserRepository) {
        self.repository = repository
    }

    func fetchRepos(queryText: String) async -> Result<[RepoEntity], Error> {
        await repository.fetchRepos(queryText: queryText)
    }
}
