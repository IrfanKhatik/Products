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
    private let networkService = NetworkService()
    var cancellable: AnyCancellable?
    
    @Published var productViewModels = [ProductViewModel]()
    @Published var isErrorPresented = false
    var errorResponse = ""
    
    @Published var searchText = ""
    @Published var filterProductViewModels = [ProductViewModel]()
    var cancellables = Set<AnyCancellable>()
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                            .makeConnectable()
                            .autoconnect()
    
    func fetchProducts() {
        cancellable = networkService.fetchProducts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: self.errorResponse = ""; self.isErrorPresented = false
                case .failure(.url(let error)) : self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                case .failure(.decode(let error)): self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                case .failure(.unknown(let error)) : self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                case .failure(.encode(let error)): self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                }
            }, receiveValue: { products in
                self.productViewModels = products.map { ProductViewModel($0)}
            })
    }
    
    init() {
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.productViewModels = []
                    return nil
                }
                
                return string
            })
            .compactMap{ $0 }
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                searchItems(searchText: searchField)
            }.store(in: &cancellables)
    }
    
    private func searchItems(searchText: String) {
        self.filterProductViewModels = self.productViewModels.filter {
            ($0.name.contains(searchText)) || ($0.desc.contains(searchText)) }
    }
}
