//
//  ImageRepository.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/27.
//
import UIKit

protocol ImageRepository {
    func loadImage(from url: URL) async throws -> UIImage
}

class MainImageRepository {
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }
}

extension MainImageRepository: ImageRepository {
    func loadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else { throw URLError(.badServerResponse) }

        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
