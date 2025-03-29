//
//  RepositoryDTO.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/27.
//

import Foundation

struct RepositoryDTO: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

    struct Repository: Decodable {
        let name: String
        let fullName: String
        let owner: User
        let description: String?
        let stargazersCount: Int
        let language: String?
        let forks: Int
        let openIssues: Int
        let watchers: Int

        struct User: Decodable {
            let avatarURL: String

            enum CodingKeys: String, CodingKey {
                case avatarURL = "avatar_url"
            }
        }

        enum CodingKeys: String, CodingKey {
            case name
            case fullName = "full_name"
            case owner
            case description
            case stargazersCount = "stargazers_count"
            case language
            case forks
            case openIssues = "open_issues"
            case watchers
        }
    }

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

extension RepositoryDTO {
    func toDomain() -> [RepoEntity] {
        items.map(RepoEntity.init)
    }
}
