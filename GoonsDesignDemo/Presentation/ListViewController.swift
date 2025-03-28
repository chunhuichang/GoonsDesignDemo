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

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let s = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: s.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: s.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: s.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: s.bottomAnchor),
        ])
    }
}

private extension ListViewController {
    func createTableView() -> UITableView {
        let v = UITableView(frame: .zero, style: .plain)
        v.registerCell(RepositoryInfoCell.self)
        v.register(RepoSearchHeaderView.self)
        v.estimatedRowHeight = 100
        v.rowHeight = UITableView.automaticDimension

        v.delegate = self
        v.dataSource = self
        v.prefetchDataSource = self
        v.refreshControl = UIRefreshControl()
        v.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)

        return v
    }

    @objc private func refreshList() {
        viewModel.refreshList()
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

extension ListViewController: RepoSearchHeaderViewDelegate {
    func didChangeSearchText(_ text: String?) {
        viewModel.search(text)
    }

    func clearText() {
        viewModel.clear()
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        120
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView: RepoSearchHeaderView = tableView.dequeueReusable() else {
            return nil
        }
        headerView.delegate = self
        return headerView
    }
}

extension ListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repos.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryInfoCell.identifier, for: indexPath) as? RepositoryInfoCell else {
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
