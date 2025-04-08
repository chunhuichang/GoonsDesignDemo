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
        addGesture()
        bindViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNaviBarVisibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNaviBarVisibility()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let heightConstraint = naviBarView.constraints.first(where: { $0.firstAttribute == .height }) {
            let topInset = view.safeAreaInsets.top
            heightConstraint.constant = topInset
        }
        updateNaviBarVisibility()
    }
}

// MARK: UI Setting

private extension ListViewController {
    func setupUI() {
        view.backgroundColor = .white

        for item in [naviBarView, tableView] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let totalHeight = statusBarHeight + navigationBarHeight

        let s = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            naviBarView.topAnchor.constraint(equalTo: view.topAnchor),
            naviBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            naviBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            naviBarView.heightAnchor.constraint(equalToConstant: totalHeight),

            tableView.leadingAnchor.constraint(equalTo: s.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: s.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: s.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: s.bottomAnchor),
        ])
    }

    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func tapView() {
        tapAction()
    }

    func updateNaviBarVisibility() {
        let headerFrame = tableView.rectForHeader(inSection: 0)
        let headerVisible = tableView.bounds.intersects(headerFrame)
        naviBarView.isHidden = headerVisible
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

    func tapAction() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
        updateNaviBarVisibility()
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        updateNaviBarVisibility()
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

// MARK: UIGestureRecognizerDelegate

extension ListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITableViewCell || touch.view?.superview is UITableViewCell {
            return false
        }
        return true
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
