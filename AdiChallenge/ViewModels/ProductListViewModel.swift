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
    
    @Published var productViewModels = [ProductViewModel]()
    
    @Published var filterProductViewModels = [ProductViewModel]()
    
    @Published var isErrorPresented = false
    
    @Published var searchText = ""
    
    var errorResponse = ""
    
    private let networkService = NetworkService()
    
    private var cancellable: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProducts() {
        
        cancellable = networkService.fetchProducts()
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                
                    case .finished: self?.errorResponse = ""; self?.isErrorPresented = false
                    
                    case .failure(.url(let error)) :        self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                    case .failure(.decode(let error)):      self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                    case .failure(.unknown(let error)) :    self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                    case .failure(.encode(let error)):      self?.errorResponse = error.localizedDescription; self?.isErrorPresented = true
                    
                }
            }, receiveValue: { [weak self] products in
                
                LoggerManager.shared.defaultLogger.log(level: .info, "[Adidas] No. of products: \(products.count, privacy: .public)")
                
                self?.productViewModels = products.map { ProductViewModel($0)}
            })
    }
    
    init() {
        
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ [weak self] (string) -> String? in
                
                if string.count < 1 {
                    
                    self?.filterProductViewModels = []
                    
                    LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Search text empty")
                    
                    return nil
                }
                
                return string
            })
            .compactMap{ $0 }
            .sink { [weak self] (_) in
                //
            } receiveValue: { [self] (searchField) in
                
                searchItems(searchText: searchField)
                
            }.store(in: &cancellables)
    }
    
    private func searchItems(searchText: String) {
        
        LoggerManager.shared.uiLogger.log(level: .info, "[Adidas] Search text: \(searchText, privacy: .public)")
        
        self.filterProductViewModels = self.productViewModels.filter {
            
            ($0.name.localizedCaseInsensitiveContains(searchText)) || ($0.desc.localizedCaseInsensitiveContains(searchText))
            
        }
    }
}
