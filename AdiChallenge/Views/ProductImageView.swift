//
//  ProductImageView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import SwiftUI

struct ProductImageView<Placeholder: View>: View {
    
    @StateObject private var loader: ProductImageLoader
    
    private let placeholder: Placeholder
    
    private let image: (UIImage) -> Image
    
    init(url: URL,
         
         @ViewBuilder placeholder: () -> Placeholder,
         
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        
        self.placeholder    = placeholder()
        self.image          = image
        _loader             = StateObject(wrappedValue: ProductImageLoader(url: url, cache: Environment(\.productImageCache).wrappedValue))
    }
    
    var body: some View {
        
        content
            .onAppear(perform: loader.load)
        
    }
    
    private var content: some View {
        Group {
            
            if loader.image != nil {
                
                Image(uiImage: loader.image!)
                    .resizable()
                
            } else {
                
                placeholder
                
            }
        }
    }
}
