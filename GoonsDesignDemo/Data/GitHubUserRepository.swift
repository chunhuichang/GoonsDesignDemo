//
//  GitHubUserRepository.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/4/8.
//

import Foundation

protocol GitHubUserRepository {
    func fetchRepos(queryText: String) async -> Result<[RepoEntity], Error>
}

struct MainGitHubUserRepository: GitHubUserRepository {
    private let session: URLSession
    private let baseURL = "https://api.github.com/search/repositories"

    public init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchRepos(queryText: String) async -> Result<[RepoEntity], Error> {
        guard let url = URL(string: "\(baseURL)?q=\(queryText)") else {
            return .failure(ServiceError.badURL)
        }

        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
                return .failure(ServiceError.invalidResponse)
            }
            let result = try JSONDecoder().decode(RepositoryDTO.self, from: data)
            return .success(result.toDomain())
        } catch {
            return .failure(error)
        }
    }
}

struct MockGitHubUserRepository: GitHubUserRepository {
    private let result: Result<[RepoEntity], Error>

    public init(result: Result<[RepoEntity], Error> = .success(RepoEntity.getMockDatas())) {
        self.result = result
    }

    func fetchRepos(queryText: String) async -> Result<[RepoEntity], any Error> {
        result
    }
}
