//
//  RepositoryInfoCell.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/27.
//

import UIKit

class RepositoryInfoCell: UITableViewCell {
    private lazy var avatarImageView = createImageView()
    private lazy var titleLabel = createTitleLabel()
    private lazy var descriptionLabel = createDescriptionLabel()

    private var imageTask: Task<Void, Never>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        avatarImageView.image = UIImage(systemName: "photo.badge.exclamationmark")
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    func configure(with entity: RepoEntity, imageRepository: ImageRepository) {
        titleLabel.text = entity.fullName
        descriptionLabel.text = entity.description
        guard let url = URL(string: entity.ownerAvatarUrl) else { return }

        imageTask?.cancel()
        imageTask = Task {
            do {
                let image = try await imageRepository.loadImage(from: url)
                avatarImageView.image = image
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}

// MARK: UI Setting

private extension RepositoryInfoCell {
    private func setupUI() {
        let stackView = createStackView()
        for item in [titleLabel, descriptionLabel] {
            stackView.addArrangedSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        for item in [avatarImageView, stackView] {
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),

            stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}

private extension RepositoryInfoCell {
    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }

    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }

    func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }

    func createStackView() -> UIStackView {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .fillEqually
        return v
    }
}

/*
 import SwiftUI

 #Preview {
     struct PreviewWrapper: UIViewRepresentable {
         func makeUIView(context: Context) -> UITableViewCell {
             let cell = RepositoryInfoCell(style: .default, reuseIdentifier: "RepositoryCell")
             cell.configure(with: RepoEntity(name: "CleanArchWithViewModel", fullName: "strannik-2357/CleanArchWithViewModel", ownerAvatarUrl: "https://avatars.githubusercontent.com/u/23434833?v=4", description: "Clean Architect with view model", language: "Kotlin", stars: 2, watchers: 1, forks: 0, issues: 0))

             // Set a fixed width for preview
 //            let width = UIScreen.main.bounds.width
 //            cell.frame = CGRect(x: 0, y: 0, width: width, height: 400)

             cell.backgroundColor = .yellow

             return cell
         }

         func updateUIView(_ uiView: UITableViewCell, context: Context) {}
     }

     return PreviewWrapper()
 }
 */
