//
//  Product.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let name : String
    let imgUrl: String
    let description: String
    let price: Double?
    let currency: String?
    var reviews: [Review]
    
    mutating func addNewReview(_ review: Review) {
        reviews.append(review)
    }
}
