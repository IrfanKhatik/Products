//
//  ProductViewModel.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation

class ProductViewModel: ObservableObject {
    private let product: Product
    
    init(_ product:Product) {
        self.product = product
    }
    
    var name: String {
        return product.name
    }
    
    var formattedPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        guard
            let price = product.price,
            let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else { return "" }
        
        return formattedPrice
    }
    
    var displayText: String {
        return name + " - " + formattedPrice
    }
    
    var desc: String {
        return product.desc
    }
}
