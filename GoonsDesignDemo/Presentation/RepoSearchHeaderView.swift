//
//  RepoSearchHeaderView.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/28.
//

import UIKit

protocol RepoSearchHeaderViewDelegate: AnyObject {
    func didChangeSearchText(_ text: String?)
    func clearText()
}

class RepoSearchHeaderView: UITableViewHeaderFooterView {
    public private(set) lazy var navigationBarTitle: UILabel = createNavigationBarTitle("Repository Search")
    public private(set) lazy var searchBar = createSearchBar()
    public weak var delegate: RepoSearchHeaderViewDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RepoSearchHeaderView {
    func setupUI() {
        contentView.backgroundColor = .white

        for item in [searchBar, navigationBarTitle] {
            contentView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            navigationBarTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            navigationBarTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            navigationBarTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            searchBar.topAnchor.constraint(equalTo: navigationBarTitle.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 52),
        ])
    }

    func createNavigationBarTitle(_ title: String) -> UILabel {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 32)
        l.textColor = .black
        l.textAlignment = .left
        l.text = title
        return l
    }

    func createSearchBar() -> UISearchBar {
        let s = UISearchBar()
        s.placeholder = "Enter Keyword to Search"
        s.delegate = self
        return s
    }
}

extension RepoSearchHeaderView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        delegate?.didChangeSearchText(searchBar.text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else {
            return
        }
        delegate?.clearText()
    }
}
