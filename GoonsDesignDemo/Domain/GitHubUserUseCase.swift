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
    func getImageRepository() -> ImageRepository
}

struct GitHubUserService: GitHubUserUseCase {
    private let repository: GitHubUserRepository
    private let imageRepository: ImageRepository

    public init(repository: GitHubUserRepository, imageRepository: ImageRepository) {
        self.repository = repository
        self.imageRepository = imageRepository
    }

    func fetchRepos(queryText: String) async -> Result<[RepoEntity], Error> {
        await repository.fetchRepos(queryText: queryText)
    }

    func getImageRepository() -> ImageRepository {
        imageRepository
    }
}
