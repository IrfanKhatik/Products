//
//  ProductListViewModel.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation
import Combine
import UIKit

class ProductListViewModel: ObservableObject {
    
    // Published property for ProductViewModels required to show on ProductListView
    @Published var productViewModels = [ProductViewModel]()
    
    // Published property for filtered ProductViewModels required to show on Search ProductListView.
    @Published var filterProductViewModels = [ProductViewModel]()
    
    // Published property if error presented for fetch products.
    @Published var isErrorPresented = false
    
    // Published property for search text for products with name and desciption
    @Published var searchText = ""
    
    // Property for keeping last network error response.
    var errorResponse = ""
    
    // Cancellable for fetch products datatask publisher.
    private var cancellable: AnyCancellable?
    
    // Cancellable to store searchText published.
    private var cancellables = Set<AnyCancellable>()
    
    // Fetch products over network REST api
    func fetchProducts() {
        
        cancellable = NetworkService.shared.fetchProducts()
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                
                case .finished: self?.errorResponse = ""; self?.isErrorPresented = false
                    
                case .failure(.url(let error)) :        self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                case .failure(.decode(let error)):      self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                case .failure(.unknown(let error)) :    self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                case .failure(.encode(let error)):      self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                    
                }
            }, receiveValue: { [weak self] products in
                
                LogManager.shared.defaultLogger.log(level: .info, "[Adidas] No. of products: \(products.count, privacy: .public)")
                
                if products.count == 0 {
                    // If products list empty then show alert.
                    self?.errorResponse = "Products not available now. Please check later!"
                    self?.isErrorPresented = true
                } else {
                    // Assign map ProductViewModel to published productViewModels.
                    self?.productViewModels = products.compactMap { ProductViewModel($0)}
                }
            })
    }
    
    init() {
        
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ [weak self] (string) -> String? in
                
                if string.count < 1 {
                    
                    self?.filterProductViewModels = []
                    
                    LogManager.shared.uiLogger.log(level: .info, "[Adidas] Search text empty")
                    
                    return nil
                }
                
                return string
            })
            .compactMap{ $0 }
            .sink { [weak self] (_) in
                //
            } receiveValue: { [self] (searchField) in
                // Search products on text change.
                searchProducts(searchText: searchField)
                
            }.store(in: &cancellables)
    }
    
    deinit {
        cancellable?.cancel()
        cancellables.compactMap{ $0.cancel() }
    }
    
    // Search products based on name or desc find for searchText.
    private func searchProducts(searchText: String) {
        
        LogManager.shared.uiLogger.log(level: .info, "[Adidas] Search text: \(searchText, privacy: .public)")
        
        self.filterProductViewModels = self.productViewModels.filter {
            
            ($0.name.localizedCaseInsensitiveContains(searchText)) || ($0.desc.localizedCaseInsensitiveContains(searchText))
            
        }
    }
}
