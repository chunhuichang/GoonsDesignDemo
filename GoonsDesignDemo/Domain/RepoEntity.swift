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

// MARK: - Mock data

extension RepoEntity {
    static let mockDatas: [RepoEntity] = [
        RepoEntity(
            name: "CleanArchWithViewModel",
            fullName: "strannik-2357/CleanArchWithViewModel",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/23434833?v=4",
            description: "", // "Clean Architecture implementation with MVVM pattern in Kotlin",
            language: "Kotlin",
            stars: 42,
            watchers: 12,
            forks: 7,
            issues: 3
        ),
        RepoEntity(
            name: "react-native-starter",
            fullName: "johndoe/react-native-starter",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/45678?v=4",
            description: "", // "Boilerplate project for React Native applications",
            language: "TypeScript",
            stars: 256,
            watchers: 45,
            forks: 89,
            issues: 16
        ),
        RepoEntity(
            name: "data-science-toolkit",
            fullName: "analyticswhiz/data-science-toolkit",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/78901?v=4",
            description: "Comprehensive collection of data science utilities and helpers",
            language: "Python",
            stars: 1024,
            watchers: 187,
            forks: 312,
            issues: 42
        ),
        RepoEntity(
            name: "express-microservices",
            fullName: "webdev-pro/express-microservices",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/56789?v=4",
            description: "Scalable microservices architecture using Express.js",
            language: "JavaScript",
            stars: 178,
            watchers: 36,
            forks: 54,
            issues: 9
        ),
        RepoEntity(
            name: "flutter-ui-kit",
            fullName: "designerx/flutter-ui-kit",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/67890?v=4",
            description: "Beautiful and customizable UI components for Flutter",
            language: "Dart",
            stars: 512,
            watchers: 78,
            forks: 143,
            issues: 22
        ),
        RepoEntity(
            name: "machine-learning-algorithms",
            fullName: "airesearcher/machine-learning-algorithms",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/89012?v=4",
            description: "Implementation of popular machine learning algorithms from scratch",
            language: "Python",
            stars: 2048,
            watchers: 456,
            forks: 789,
            issues: 67
        ),
        RepoEntity(
            name: "vue-ecommerce-app",
            fullName: "webshop-dev/vue-ecommerce-app",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/34567?v=4",
            description: "Full-featured e-commerce platform built with Vue.js",
            language: "Vue",
            stars: 321,
            watchers: 56,
            forks: 98,
            issues: 14
        ),
        RepoEntity(
            name: "android-jetpack-compose",
            fullName: "androiddev/android-jetpack-compose",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/23456?v=4",
            description: "Modern Android UI toolkit using Jetpack Compose",
            language: "Kotlin",
            stars: 765,
            watchers: 132,
            forks: 276,
            issues: 37
        ),
        RepoEntity(
            name: "rust-systems-programming",
            fullName: "systemsdev/rust-systems-programming",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/45678?v=4",
            description: "Low-level systems programming utilities and examples in Rust",
            language: "Rust",
            stars: 512,
            watchers: 87,
            forks: 156,
            issues: 24
        ),
        RepoEntity(
            name: "nodejs-backend-template",
            fullName: "backendpro/nodejs-backend-template",
            ownerAvatarUrl: "https://avatars.githubusercontent.com/u/56789?v=4",
            description: "Production-ready Node.js backend template with best practices",
            language: "JavaScript",
            stars: 412,
            watchers: 67,
            forks: 112,
            issues: 18
        )
    ]

    static func getMockDatas(_ repeatCount: Int = 10) -> [RepoEntity] {
        Array(repeating: mockDatas, count: repeatCount).flatMap { $0 }
    }
}
