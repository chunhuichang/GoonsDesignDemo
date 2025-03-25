//
//  ListViewController.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/25.
//

import UIKit

public protocol ListViewControllerDelegate: AnyObject {
    func goToDetail()
}

class ListViewController: UIViewController {
    public private(set) lazy var nameLabel: UILabel = createNameLabel()

    private weak var delegate: ListViewControllerDelegate?

    init(delegate: ListViewControllerDelegate) {
        self.delegate = delegate
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

private extension ListViewController {
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

private extension ListViewController {
    func createNameLabel() -> UILabel {
        let l = UILabel()
        l.text = "List View"
        l.textColor = .blue
        l.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.itemClicked))
        l.addGestureRecognizer(tapGesture)
        return l
    }

    @objc private func itemClicked() {
        self.delegate?.goToDetail()
    }
}
