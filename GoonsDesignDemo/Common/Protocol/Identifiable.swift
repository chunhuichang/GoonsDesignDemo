//
//  Identifiable.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/28.
//

import Foundation

public protocol Identifiable {
    static var identifier: String { get }
}

public extension Identifiable {
    static var identifier: String {
        String(describing: self)
    }
}
