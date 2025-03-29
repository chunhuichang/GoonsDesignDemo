//
//  RepoEntity.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/26.
//

import Foundation

public struct RepoEntity: Decodable {
    let name: String
    let fullName: String
    let ownerAvatarUrl: String
    let description: String
    let language: String
    let stars: Int
    let watchers: Int
    let forks: Int
    let issues: Int

    init(name: String, fullName: String, ownerAvatarUrl: String, description: String, language: String, stars: Int, watchers: Int, forks: Int, issues: Int) {
        self.name = name
        self.fullName = fullName
        self.ownerAvatarUrl = ownerAvatarUrl
        self.description = description
        self.language = language
        self.stars = stars
        self.watchers = watchers
        self.forks = forks
        self.issues = issues
    }

    init(_ dto: RepositoryDTO.Repository) {
        name = dto.name
        fullName = dto.fullName
        ownerAvatarUrl = dto.owner.avatarURL
        description = dto.description ?? ""
        language = dto.language ?? ""
        stars = dto.stargazersCount
        watchers = dto.watchers
        forks = dto.forks
        issues = dto.openIssues
    }
}
