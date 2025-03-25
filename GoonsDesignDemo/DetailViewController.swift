//
//  DetailViewController.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/24.
//

import UIKit

class DetailViewController: UIViewController {
    public private(set) lazy var nameLabel: UILabel = createNameLabel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
}

// MARK: UI Setting

private extension DetailViewController {
    func setupUI() {
        self.view.backgroundColor = .white

        for item in [self.nameLabel] {
            self.view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        let s = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.nameLabel.centerXAnchor.constraint(equalTo: s.centerXAnchor),
            self.nameLabel.centerYAnchor.constraint(equalTo: s.centerYAnchor),
        ])
    }
}

private extension DetailViewController {
    func createNameLabel() -> UILabel {
        let l = UILabel()
        l.text = "Detail View"
        l.textColor = .red
        return l
    }
}
