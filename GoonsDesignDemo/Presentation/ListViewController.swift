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
    public private(set) lazy var naviBarView: UIView = createNaviBarView()

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

        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
            let totalHeight = statusBarHeight + navigationBarHeight

            naviBarView.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(naviBarView)
            NSLayoutConstraint.activate([
                naviBarView.topAnchor.constraint(equalTo: window.topAnchor),
                naviBarView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                naviBarView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                naviBarView.heightAnchor.constraint(equalToConstant: totalHeight),
            ])
        }

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
        let v = UITableView(frame: .zero, style: .grouped)
        v.backgroundColor = .white
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

    func createNaviBarLabel() -> UILabel {
        let l = UILabel()
        l.text = "Repository Search"
        l.font = .boldSystemFont(ofSize: 20)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }

    func createNaviBarView() -> UIView {
        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.7)

        let l = createNaviBarLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(l)

        NSLayoutConstraint.activate([
            l.leadingAnchor.constraint(equalTo: v.leadingAnchor),
            l.trailingAnchor.constraint(equalTo: v.trailingAnchor),
            l.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -12),
        ])

        v.isHidden = true
        return v
    }

    @objc private func refreshList() {
        viewModel.refreshList()
    }

    func showEmptyInputAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "The data couldn't be read because it is missing.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        naviBarView.isHidden = true
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        naviBarView.isHidden = false
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
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
            })
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] isError in
                guard isError else { return }
                self?.showEmptyInputAlert()
            }
            .store(in: &cancellables)
    }
}
