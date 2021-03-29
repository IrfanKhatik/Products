//
//  Review.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import Foundation

// Model class for product review
struct Review: Codable, Identifiable, CustomStringConvertible {
    
    var description: String {
        
        var description = ""
        description     += "productId: \(self.productId ?? "")\n"
        description     += "locale: \(self.locale ?? "")\n"
        description     += "rating: \(self.rating ?? 0)\n"
        description     += "text: \(self.text ?? "")\n"
        
        return description
    }
    
    var id : String {
        
        return self.productId ?? "" + UUID().uuidString
        
    }
    
    var productId: String?
    var locale: String?
    var rating: Int? = 0
    var text: String?
    
    enum CodingKeys: String, CodingKey {
        case productId
        case locale
        case rating
        case text
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.productId  = try values.decode(String.self, forKey: .productId)
        self.locale     = try values.decode(String.self, forKey: .locale)
        self.rating     = try values.decode(Int.self, forKey: .rating)
        self.text       = try values.decode(String.self, forKey: .text)
    }
    
    init(id: String, locale: String, rating:Int, text: String ) {
        self.productId  = id
        self.locale     = locale
        self.rating     = rating
        self.text       = text
    }
}
