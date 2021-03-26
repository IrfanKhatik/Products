//
//  Product.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 26/03/21.
//

import Foundation

struct Product: Decodable, Identifiable {
    var id: String
    let name : String
    let image: String
    let desc: String
    let price: Double?
}
