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
    
    // Published property for downloaded and prepared UImage.
    @Published var image: UIImage?
    
    // Serial image downloading queue.
    private static let imageDownloadingQueue = DispatchQueue(label: "com.adichallenge.image-downloading.queue")
    
    // Downloading status
    private(set) var isDownloading = false
    
    // Image url for download
    private let url: URL?
    
    // Cache image after download.
    private var cache: ProductImageCache?
    
    // Cancellable for download image datatask publisher.
    private var cancellable: AnyCancellable?
    
    init(url: URL?, cache: ProductImageCache? = nil) {
        self.url    = url
        self.cache  = cache
    }
    
    deinit {
        
        cancellable?.cancel()
        
    }
    
    // Fetch image from network request
    func load() {
        
        guard !isDownloading else { return }
        
        guard let url = url else { return }
        
        // Provide cached image if available.
        if let image = cache?[url] {
            
            self.image = image
            
            LogManager.shared.defaultLogger.log(level: .debug, "[Adidas] Image cached available: \(url.lastPathComponent, privacy: .public)")
            
            return
        }
        
        // Download image datatask publisher.
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
    
    // On cancel image download datatask publisher
    func cancel() {
        
        // Reset isLoading flag
        isDownloading = false
        
        cancellable?.cancel()
        
        LogManager.shared.defaultLogger.log(level: .debug, "[Adidas] Image download cancelled: \(self.url?.lastPathComponent ?? "", privacy: .public)")
        
    }
    
    // On start image download datatask.
    private func onStart() {
        
        // Set isLoading flag
        isDownloading = true
        
        LogManager.shared.defaultLogger.log(level: .debug, "[Adidas] Image download started: \(self.url?.lastPathComponent ?? "", privacy: .public)")
        
    }
    
    // On finish image download datatask.
    private func onFinish() {
        
        // Reset isLoading flag
        isDownloading = false
        
        LogManager.shared.defaultLogger.log(level: .debug, "[Adidas] Image download finished: \(self.url?.lastPathComponent ?? "", privacy: .public)")
        
    }
    
    // On reciev image download output from datatask publisher.
    private func cache(_ image: UIImage?) {
        
        guard let url = url else { return }
        
        // Cache image for given url. Maximum 100 MB allowed.
        image.map { cache?[url] = $0 }
        
        LogManager.shared.defaultLogger.log(level: .debug, "[Adidas] Image downloaded cache: \(url.lastPathComponent, privacy: .public)")
    }
}
