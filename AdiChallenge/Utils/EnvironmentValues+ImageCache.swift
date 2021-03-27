//
//  EnvironmentValues+ImageCache.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductImageCacheKey: EnvironmentKey {
    static let defaultValue: ProductImageCache = TemporaryProductImageCache()
}

extension EnvironmentValues {
    var productImageCache: ProductImageCache {
        get { self[ProductImageCacheKey.self] }
        set { self[ProductImageCacheKey.self] = newValue }
    }
}
