//
//  ProductImageView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductImageView<Placeholder: View>: View {
    
    // Image loader as viewmodel to download image.
    @StateObject private var loader: ProductImageLoader
    
    // Property for Placeholder view for product image.
    private let placeholder: Placeholder
    
    // Closure property to convert UImage once its dowloaded.
    private let image: (UIImage) -> Image
    
    init(url: URL?,
         
         @ViewBuilder placeholder: () -> Placeholder,
         
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        
        self.placeholder    = placeholder()
        self.image          = image
        _loader             = StateObject(wrappedValue: ProductImageLoader(url: url, cache: Environment(\.productImageCache).wrappedValue))
    }
    
    var body: some View {
        // Execute image load on appear
        content
            .onAppear(perform: loader.load)
        
    }
    
    private var content: some View {
        Group {
            
            if loader.image != nil {
                // Assign image once its available
                Image(uiImage: loader.image!)
                    .resizable()
                
            } else {
                // Else show placeholder until then
                placeholder
                
            }
        }
    }
}
