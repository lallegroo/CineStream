//
//  ImageCacheService.swift
//  CineStream
//
//  Created by Akash Ingawale on 24/05/25.
//

import Foundation
import SwiftUI
import Combine

class ImageCacheService {

    // MARK: Constants

    static let shared = ImageCacheService()

    // MARK: Properties

    private let cache = LRUImageCache<String, UIImage>(capacity: 50)
    private let imageProcessingQueue = DispatchQueue(label: "com.cinestream.imageprocessing")

    // MARK: Inits

    private init() {}

    // MARK: Public Methods

    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
        // Check if image is in cache
        let urlString = url.absoluteString
        if let cachedImage = cache.get(urlString) {
            return Just(cachedImage).eraseToAnyPublisher()
        }

        // If not in cache, download and cache
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .handleEvents(receiveOutput: { [weak self] image in
                guard let self = self, let image = image else { return }
                self.imageProcessingQueue.async {
                    self.cache.set(urlString, value: image)
                }
            })
            .replaceError(with: nil)
            .subscribe(on: imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func clearCache() {
        cache.removeAll()
        print("Image cache cleared")
    }
}

struct CachedAsyncImage<Content: View>: View {

    // MARK: Properties

    @StateObject private var loader: ImageLoader
    private let content: (Image?) -> Content

    // MARK: Inits

    init(url: URL?, @ViewBuilder content: @escaping (Image?) -> Content) {
        self._loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        content(loader.image.map(Image.init(uiImage:)))
            .onAppear(perform: loader.load)
    }
}

class ImageLoader: ObservableObject {

    // MARK: Properties

    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private let url: URL?

    // MARK: Inits

    fileprivate init(url: URL?) {
        self.url = url
    }

    // MARK: Inits

    fileprivate func load() {
        guard let url = url else { return }

        cancellable = ImageCacheService.shared.image(for: url)
            .sink { [weak self] image in
                self?.image = image
            }
    }

    deinit {
        cancellable?.cancel()
    }
}
