//
//  ProductViewModel.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject, Identifiable {
    
    @Published var reviewResult = false
    
    var errorResponse = ""
    
    private var cancellable: AnyCancellable?
    
    private var product: Product
    
    private let networkService = NetworkService()
    
    init(_ product:Product) {
        
        self.product = product
        
    }
    
    var id: String {
        
        return product.id ?? ""
        
    }
    
    var name: String {
        
        return product.name?.capitalized ?? ""
        
    }
    
    var imageUrl : String {
        
        return product.imgUrl ?? ""
        
    }
    
    var formattedPrice: String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        // Prepare price with provided currrency else device locale
        if let locale = product.currency, !locale.isEmpty {
            numberFormatter.locale  = Locale(identifier: locale)
        }
        
        guard
            let price           = product.price,
            let formattedPrice  = numberFormatter.string(from: NSNumber(value: price)) else { return "" }
        
        return formattedPrice
    }
    
    var desc: String {
        
        return product.desc?.uppercased() ?? ""
        
    }
    
    var reviews: [Review] {
        
        return product.reviews ?? []
        
    }
    
    func submitReview(_ review: Review) {
        cancellable = networkService.submitReview(review)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                
                case .finished: self?.errorResponse = ""
                    
                case .failure(.url(let error)) :        self?.errorResponse = error.localizedDescription
                case .failure(.decode(let error)):      self?.errorResponse = error.localizedDescription
                case .failure(.unknown(let error)) :    self?.errorResponse = error.localizedDescription
                case .failure(.encode(let error)):      self?.errorResponse = error.localizedDescription
                
                }
            }, receiveValue: { [weak self] result in
                
                LoggerManager.shared.defaultLogger.log(level: .debug, "[Adidas] Review submittted: \(result, privacy: .public)")
                
                if
                    let code = result["error"] as? String, !code.isEmpty {
                    self?.errorResponse = result["message"] as? String ?? "Failed to submit review. Please try later"
                } else {
                    // Append review into review list after successful
                    self?.product.addNewReview(review)
                }
                
                self?.reviewResult = true
            })
    }
}
