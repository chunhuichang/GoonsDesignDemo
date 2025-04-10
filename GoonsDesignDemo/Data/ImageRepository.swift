//
//  ImageRepository.swift
//  GoonsDesignDemo
//
//  Created by Jill Chang on 2025/3/27.
//
import Foundation

protocol ImageRepository {
    func loadImageData(from url: URL) async throws -> Data
}

class MainImageRepository {
    private let cache = NSCache<NSURL, NSData>()
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }
}

extension MainImageRepository: ImageRepository {
    func loadImageData(from url: URL) async throws -> Data {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage as Data
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        cache.setObject(data as NSData, forKey: url as NSURL)
        return data
    }
}
