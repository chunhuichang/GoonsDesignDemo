//
//  DetailViewModel.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/26.
//

import Combine
import UIKit

class DetailViewModel: ObservableObject {
    @Published private(set) var nameText: String
    @Published private(set) var fullNameText: String
    @Published private(set) var ownerAvatarImage: UIImage?
    @Published private(set) var languageText: String
    @Published private(set) var starsText: String
    @Published private(set) var watchersText: String
    @Published private(set) var forksText: String
    @Published private(set) var issuesText: String
    @Published private(set) var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let imageRepository: ImageRepository

    init(entity: RepoEntity, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        self.nameText = entity.name
        self.fullNameText = entity.fullName
        self.languageText = "Written in \(entity.language)"
        // TODO: Localizable
        self.starsText = "\(entity.stars) \(entity.stars > 1 ? "stars" : "star")"
        self.watchersText = "\(entity.watchers) \(entity.watchers > 1 ? "watchers" : "watcher")"
        self.forksText = "\(entity.forks) \(entity.forks > 1 ? "forks" : "fork")"
        self.issuesText = "\(entity.issues) \(entity.issues > 1 ? "issues" : "issue")"
        self.fetchOwnerAvatar(from: entity.ownerAvatarUrl)
    }

    private func fetchOwnerAvatar(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        Task {
            self.isLoading = true
            do {
                let data = try await imageRepository.loadImageData(from: url)
                await MainActor.run {
                    self.ownerAvatarImage = UIImage(data: data)
                    self.isLoading = false
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}
