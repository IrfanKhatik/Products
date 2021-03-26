//
//  ProductsView.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import SwiftUI

struct ProductsView: View {
    @StateObject var viewModel = ProductListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.productViewModels, id: \.self) { productViewModel in
                Text(productViewModel.displayText)
            }.onAppear(perform: {
                viewModel.fetchProducts()
            }).navigationBarTitle("Products")
        }
    }
}

struct ProductViewCell: View {
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
