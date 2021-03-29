//
//  ProductViewModel.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject, Identifiable {
    
    // Published property for POST product review status.
    @Published var reviewResult = false
    
    // Property for keeping last network error response.
    var errorResponse = ""
    
    // Cancellable for POST product review datatask publisher.
    private var cancellable: AnyCancellable?
    
    // Property holding Product.
    private var product: Product
    
    init(_ product:Product) {
        // Dependancy injection
        self.product = product
        
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    // Computed property for product id
    var id: String {
        
        return product.id ?? ""
        
    }
    
    // Computed property for product name
    var name: String {
        
        return product.name?.capitalized ?? ""
        
    }
    
    // Computed property for product image
    var imageUrl : String {
        
        return product.imgUrl ?? ""
        
    }
    
    // Computed property for product price
    private var price: NSNumber? {
        guard
            let price           = product.price, price >= 0.0 else {
            return nil
        }
        
        return NSNumber(value:price)
    }
    
    // Computed property for product formatted price based on current locale.
    // Prepare price with provided currrency else empty
    var formattedPrice: String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        guard
            let locale = product.currency,
              !locale.isEmpty,
              Locale.availableIdentifiers.contains(locale) else {
            return ""
        }
        
        numberFormatter.locale  = Locale(identifier: locale)
        
        guard
            let price = self.price,
            let formattedPrice = numberFormatter.string(from: price) else {
            return ""
        }
        
        return formattedPrice
    }
    
    // Computed property for product desciption
    var desc: String {
        
        return product.desc?.uppercased() ?? ""
        
    }
    
    // Computed property for product reviews.
    var reviews: [Review] {
        
        return product.reviews ?? []
        
    }
    
    // Submit review over network REST api.
    func submitReview(_ review: Review) {
        cancellable = NetworkService.shared.submitReview(review)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                
                case .finished: self?.errorResponse = ""
                    
                case .failure(.url(let error)) :        self?.errorResponse = error.localizedDescription
                case .failure(.decode(let error)):      self?.errorResponse = error.localizedDescription
                case .failure(.unknown(let error)) :    self?.errorResponse = error.localizedDescription
                case .failure(.encode(let error)):      self?.errorResponse = error.localizedDescription
                
                }
            }, receiveValue: { [weak self] result in
                
                LogManager.shared.defaultLogger.log(level: .debug, "[Adidas] Review submittted: \(result, privacy: .public)")
                
                if let code = result["error"] as? String, !code.isEmpty {
                    
                    let statusCode = result["statusCode"] as? Int64 ?? 500
                    let message = result["message"] as? String ?? "Please try later!"
                    
                    // Prepare error response.
                    self?.errorResponse = "\(code) (\(statusCode))" + " : " + message
                    
                } else {
                    // Append review into review list after successful
                    self?.product.addNewReview(review)
                }
                
                // Update published review status to show review status alert.
                self?.reviewResult = true
            })
    }
}
