//
//  DetailViewController.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/24.
//

import Combine
import UIKit

public protocol DetailViewControllerDelegate: AnyObject {
    func dismiss()
}

class DetailViewController: UIViewController {
    public private(set) lazy var nameLabel: UILabel = createNameLabel()
    public private(set) lazy var fullNameLabel: UILabel = createFullNameLabel()
    public private(set) lazy var languageLabel: UILabel = createLanguageLabel()
    public private(set) lazy var starsCountLabel: UILabel = createStarsCountLabel()
    public private(set) lazy var watchersCountLabel: UILabel = createWatchersCountLabel()
    public private(set) lazy var forksCountLabel: UILabel = createForksCountLabel()
    public private(set) lazy var issuesCountLabel: UILabel = createIssuesCountLabel()
    public private(set) lazy var ownerImageView: UIImageView = createOwnerImageView()

    private weak var delegate: DetailViewControllerDelegate?
    public let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init(delegate: DetailViewControllerDelegate, viewModel: DetailViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.bindViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.dismiss()
    }
}

// MARK: UI Setting

private extension DetailViewController {
    func setupUI() {
        self.view.backgroundColor = .white

        for item in [self.ownerImageView, self.nameLabel, self.fullNameLabel, self.languageLabel, self.starsCountLabel, self.watchersCountLabel, self.forksCountLabel, self.issuesCountLabel] {
            self.view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        let s = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: s.topAnchor, constant: 20),
            self.nameLabel.leadingAnchor.constraint(equalTo: s.leadingAnchor, constant: 20),
            self.nameLabel.trailingAnchor.constraint(equalTo: s.trailingAnchor, constant: -20),

            self.ownerImageView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
            self.ownerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.ownerImageView.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.ownerImageView.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),
            self.ownerImageView.heightAnchor.constraint(equalTo: self.ownerImageView.widthAnchor, multiplier: 1),

            self.fullNameLabel.topAnchor.constraint(equalTo: self.ownerImageView.bottomAnchor, constant: 20),
            self.fullNameLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.fullNameLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),

            self.languageLabel.topAnchor.constraint(equalTo: self.fullNameLabel.bottomAnchor, constant: 20),
            self.languageLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.languageLabel.trailingAnchor.constraint(equalTo: s.centerXAnchor),

            self.starsCountLabel.topAnchor.constraint(equalTo: self.languageLabel.topAnchor),
            self.starsCountLabel.leadingAnchor.constraint(equalTo: s.centerXAnchor),
            self.starsCountLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),

            self.watchersCountLabel.topAnchor.constraint(equalTo: self.starsCountLabel.bottomAnchor, constant: 8),
            self.watchersCountLabel.leadingAnchor.constraint(equalTo: self.starsCountLabel.leadingAnchor),
            self.watchersCountLabel.trailingAnchor.constraint(equalTo: self.starsCountLabel.trailingAnchor),

            self.forksCountLabel.topAnchor.constraint(equalTo: self.watchersCountLabel.bottomAnchor, constant: 8),
            self.forksCountLabel.leadingAnchor.constraint(equalTo: self.starsCountLabel.leadingAnchor),
            self.forksCountLabel.trailingAnchor.constraint(equalTo: self.starsCountLabel.trailingAnchor),

            self.issuesCountLabel.topAnchor.constraint(equalTo: self.forksCountLabel.bottomAnchor, constant: 8),
            self.issuesCountLabel.leadingAnchor.constraint(equalTo: self.starsCountLabel.leadingAnchor),
            self.issuesCountLabel.trailingAnchor.constraint(equalTo: self.starsCountLabel.trailingAnchor),
        ])
    }
}

private extension DetailViewController {
    func createNameLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        return l
    }

    func createFullNameLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24)
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        return l
    }

    func createLanguageLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 16)
        return l
    }

    func createStarsCountLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .right
        return l
    }

    func createWatchersCountLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .right
        return l
    }

    func createForksCountLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .right
        return l
    }

    func createIssuesCountLabel() -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.textAlignment = .right
        return l
    }

    func createOwnerImageView() -> UIImageView {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        v.image = UIImage(systemName: "photo.badge.exclamationmark")
        return v
    }
}

// MARK: UI Binding

private extension DetailViewController {
    func bindViewModel() {
        self.viewModel.$nameText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.nameLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$fullNameText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.fullNameLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$languageText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.languageLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$starsText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.starsCountLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$watchersText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.watchersCountLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$forksText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.forksCountLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$issuesText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.issuesCountLabel.text = text
            }
            .store(in: &self.cancellables)

        self.viewModel.$ownerAvatarImage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.ownerImageView.image = image
            }
            .store(in: &self.cancellables)
    }
}
