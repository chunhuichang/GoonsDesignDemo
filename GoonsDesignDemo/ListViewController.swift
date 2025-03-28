//
//  ListViewController.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/25.
//

import Combine
import UIKit

class ListViewController: UIViewController {
    public private(set) lazy var tableView: UITableView = createTableView()
    public private(set) lazy var searchBar = createSearchBar()

    private let viewModel: ListViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
}

// MARK: UI Setting

private extension ListViewController {
    func setupUI() {
        view.backgroundColor = .white

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Repository Search"

        for item in [searchBar, tableView] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        let s = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: s.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: s.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: s.topAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),

            tableView.leadingAnchor.constraint(equalTo: s.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: s.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: s.bottomAnchor),
        ])
    }
}

private extension ListViewController {
    func createTableView() -> UITableView {
        let v = UITableView(frame: .zero, style: .plain)
        v.register(RepositoryInfoCell.self, forCellReuseIdentifier: "RepositoryInfoCell")
        v.delegate = self
        v.dataSource = self
        v.prefetchDataSource = self
        v.refreshControl = UIRefreshControl()
        v.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)

        return v
    }

    @objc private func refreshList() {
        viewModel.search(searchBar.text)
    }

    func createSearchBar() -> UISearchBar {
        let s = UISearchBar()
        s.placeholder = "Enter Keyword to Search"
        s.delegate = self
        return s
    }

    func showEmptyInputAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "The data couldn't be read because it is missing.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.tableView.refreshControl?.endRefreshing()
        }
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath.row)
    }
}

extension ListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repos.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryInfoCell", for: indexPath) as? RepositoryInfoCell else {
            return UITableViewCell()
        }
        let row = viewModel.repos[indexPath.row]
        cell.configure(with: row)
        return cell
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let imageURL = URL(string: viewModel.repos[indexPath.row].ownerAvatarUrl) {
                Task {
                    _ = try? await ImageLoader.shared.loadImage(from: imageURL)
                }
            }
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(searchBar.text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else {
            return
        }

        viewModel.clear()
    }
}

// MARK: UI Binding

private extension ListViewController {
    func bindViewModel() {
        viewModel.$repos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorInput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isError in
                guard isError else { return }
                self?.showEmptyInputAlert()
            }
            .store(in: &cancellables)
    }
}
