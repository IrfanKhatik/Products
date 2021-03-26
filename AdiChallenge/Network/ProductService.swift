//
//  ProductService.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import Foundation

import Foundation
import Combine // A declarative Swift API for processing values over time

enum ProductError: Error, CustomStringConvertible {
    case url(URLError)
    case decode(Error)
    case unknown(Error)
    
    // 2
    var description: String {
        switch self {
        case .url(let error):
            return "Request to API Server failed \(error.localizedDescription)"
        case .decode(let error):
            return "Failed parsing response from server \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown \(error.localizedDescription)"
        }
    }
}

final class ProductService {
    
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coinranking.com"
        components.path = "/v2/coins"
        components.queryItems = [URLQueryItem(name: "orderBy", value: "price"),
                                 URLQueryItem(name: "timePeriod", value: "24h")]
        
        return components
    }
    
    func fetchProducts() -> AnyPublisher<ProductDataContainer, ProductError> {
        let request: URLRequest = URLRequest(url: components.url!)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ProductDataContainer.self, decoder: JSONDecoder())
            .mapError { error -> ProductError in
                switch error {
                    case is DecodingError: return ProductError.decode(error)
                    case is URLError: return ProductError.url(error as! URLError)
                    default: return ProductError.unknown(error)
                }
            }
            .retry(3)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct ProductDataContainer: Decodable {
    let status: String
    let data: ProductData
}

struct ProductData: Decodable {
    let products: [Product]
}
