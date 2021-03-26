//
//  ProductListViewModel.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    private let productService = ProductService()
    
    @Published var productViewModels = [ProductViewModel]()
    @Published var errorResponse = ""
    
    var cancellable: AnyCancellable?
    
    func fetchProducts() {
        cancellable = productService.fetchProducts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(.url(let error)) : print("❗️ url failure: \(error)")
                case .failure(.decode(let error)): print("❗️ decode failure: \(error)")
                case .failure(.unknown(let error)) : print("❗️ unknown failure: \(error.localizedDescription)")
                }
            }, receiveValue: { productsContainer in
                self.productViewModels = productsContainer.data.products.map { ProductViewModel($0)}
            })
    }
}
