//
//  UIViewExt.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/4/12.
//

import UIKit

public extension UIView {
    private var skeletonViewTag: Int { 987654 }

    func addSkeleton(cornerRadius: CGFloat = 8) {
        removeSkeleton()

        let skeleton = SkeletonView()
        skeleton.layer.cornerRadius = cornerRadius
        skeleton.tag = skeletonViewTag
        skeleton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(skeleton)
        sendSubviewToBack(skeleton)

        NSLayoutConstraint.activate([
            skeleton.topAnchor.constraint(equalTo: topAnchor),
            skeleton.bottomAnchor.constraint(equalTo: bottomAnchor),
            skeleton.leadingAnchor.constraint(equalTo: leadingAnchor),
            skeleton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        if let label = self as? UILabel, label.text?.isEmpty ?? true {
            label.text = "     " // Prevents zero width/height issues
        }
    }

    func removeSkeleton() {
        subviews
            .filter { $0.tag == skeletonViewTag }
            .forEach { $0.removeFromSuperview() }
    }
}
