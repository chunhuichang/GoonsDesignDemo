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

protocol GitHubUserServiceProtocol {
    func fetchRepos(queryText: String) async -> Result<[RepoEntity], Error>
}

class GitHubUserService: GitHubUserServiceProtocol {
    static let shared = GitHubUserService()
    private let session: URLSession = .shared
    private let baseURL = "https://api.github.com/search/repositories"

    private init() {}

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
