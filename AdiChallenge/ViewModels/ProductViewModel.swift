//
//  ProductViewModel.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject, Identifiable {
    private var product: Product
    
    private let networkService = NetworkService()
    var cancellable: AnyCancellable?
    
    @Published var isErrorPresented = false
    @Published var isSubmittedReview = false
    
    var errorResponse = ""
    
    init(_ product:Product) {
        self.product = product
    }
    
    var id: String {
        return product.id
    }
    
    var name: String {
        return product.name
    }
    
    var imageUrl : String {
        return product.imgUrl
    }
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        if let locale = product.currency {
            numberFormatter.locale = Locale(identifier: locale)
        }
        
        guard
            let price = product.price,
            let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else { return "" }
        
        return formattedPrice
    }
    
    var desc: String {
        return product.description
    }
    
    var reviews: [Review] {
        return product.reviews
    }
    
    func submitReview(_ review: Review) {
        cancellable = networkService.submitReview(review)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: self.product.addNewReview(review); self.errorResponse = ""; self.isErrorPresented = false
                case .failure(.url(let error)) : self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                case .failure(.decode(let error)): self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                case .failure(.unknown(let error)) : self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                case .failure(.encode(let error)): self.errorResponse = error.localizedDescription; self.isErrorPresented = true
                }
            }, receiveValue: { [weak self] result in
                print("Review submitted: \(result)")
                self?.isSubmittedReview = result
            })
    }
}
