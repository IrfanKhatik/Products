//
//  Product.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation

struct Product: Codable, Identifiable, CustomStringConvertible {
    
    var description: String {
        
        var description = ""
        description     += "id: \(self.id)\n"
        description     += "name: \(self.name)\n"
        description     += "imageUrl: \(self.imgUrl)\n"
        description     += "desc: \(self.desc)\n"
        description     += "price: \(self.price ?? 0.0)\n"
        description     += "currency: \(self.currency ?? "")\n"
        description     += "reviews: \(self.reviews.description)\n"
        
        return description
        
    }
    
    let id: String
    let name : String
    let imgUrl: String
    let desc: String
    let price: Double?
    let currency: String?
    var reviews: [Review]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imgUrl
        case desc       = "description"
        case price
        case currency
        case reviews
    }
    
    mutating func addNewReview(_ review: Review) {
        reviews.append(review)
    }
}
