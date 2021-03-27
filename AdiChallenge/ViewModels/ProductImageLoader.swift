//
//  ProductImageLoader.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import Foundation
import Combine
import UIKit

class ProductImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private static let imageDownloadingQueue = DispatchQueue(label: "com.adichallenge.image-downloading.queue")
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cache: ProductImageCache?
    private var cancellable: AnyCancellable?
    
    init(url: URL, cache: ProductImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .delay(for: 1, scheduler: DispatchQueue.global())
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageDownloadingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
        
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}