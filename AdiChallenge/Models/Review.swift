//
//  Review.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import Foundation

struct Review: Codable, Identifiable, CustomStringConvertible {
    
    var description: String {
        
        var description = ""
        description     += "productId: \(self.id)\n"
        description     += "locale: \(self.locale)\n"
        description     += "rating: \(self.rating)\n"
        description     += "text: \(self.text)\n"
        
        return description
    }
    
    var id: String
    var locale: String
    var rating: Int
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case id     = "productId"
        case locale
        case rating
        case text
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id     = try values.decode(String.self, forKey: .id)
        self.locale = try values.decode(String.self, forKey: .locale)
        self.rating = try values.decode(Int.self, forKey: .rating)
        self.text   = try values.decode(String.self, forKey: .text)
    }
    
    init(id: String, locale: String, rating:Int, text: String ) {
        self.id     = id
        self.locale = locale
        self.rating = rating
        self.text   = text
    }
}
