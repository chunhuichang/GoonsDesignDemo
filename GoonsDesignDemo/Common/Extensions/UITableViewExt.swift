//
//  UITableViewExt.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/28.
//

import UIKit

// MARK: - UITableViewCell

extension UITableViewCell: Identifiable {}

public extension UITableView {
    func registerCell<T>(_ clazz: T.Type) where T: UITableViewCell {
        register(clazz, forCellReuseIdentifier: T.identifier)
    }

    func dequeueReusable<T>(for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let v = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return T()
        }
        return v
    }
}

// MARK: - UITableViewHeaderFooterView

extension UITableViewHeaderFooterView: Identifiable {}

public extension UITableView {
    func register<T>(_ clazz: T.Type) where T: UITableViewHeaderFooterView {
        register(clazz, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    func dequeueReusable<T>() -> T? where T: UITableViewHeaderFooterView {
        dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T //?? nil
    }
}
