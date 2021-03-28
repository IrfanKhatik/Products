//
//  NetworkService.swift
//  AdiChallenge
//
//  Created by Irfan Khatik on 27/03/21.
//

import Foundation

import Foundation
import Combine // A declarative Swift API for processing values over time

enum NetworkError: Error, CustomStringConvertible {
    var description: String {
        return self.errorDescription
    }
    
    case url(URLError)
    case decode(DecodingError)
    case encode(EncodingError)
    case unknown(Error)
    
    var errorDescription: String {
        switch self {
        case .url(let error):       return "Request to API Server failed \(error.localizedDescription)"
        case .decode(let error):    return "Failed parsing response from server \(error.localizedDescription)"
        case .encode(let error):    return "Failed to encode \(error.localizedDescription)"
        case .unknown(let error):   return "Unknown \(error.localizedDescription)"
        }
    }
}

final class NetworkService {
    
    // Fetch all products
    func fetchProducts() -> AnyPublisher<[Product], NetworkError> {
        var productURLComponents: URLComponents {
            var components = URLComponents()
            
            components.scheme   = "http"
            components.port     = 3001
            components.host     = "localhost"
            components.path     = "/product"
            
            return components
        }
        
        let dummy: Product = Product(id: "", name: "", imgUrl: "", desc: "", price: 0, currency: "", reviews: [])
        guard let productUrl = productURLComponents.url else {
            
            LoggerManager.shared.networkLogger.log(level: .error, "[Adidas] GET Products url invalid \(productURLComponents, privacy: .private(mask: .hash))")
            
            return Just([dummy])
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        var request: URLRequest = URLRequest(url: productUrl)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                LoggerManager.shared.networkLogger.log(level: .error,"[Adidas] GET products error response: \(error as NSError, privacy: .private)")
                switch error {
                case is DecodingError:  return NetworkError.decode(error as! DecodingError)
                case is URLError:       return NetworkError.url(error as! URLError)
                default:                return NetworkError.unknown(error)
                }
            }
            .retry(3)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // Submit review
    func submitReview(_ review: Review) -> AnyPublisher<[String: Any], NetworkError> {
        
        var reviewURLComponents: URLComponents {
            var components = URLComponents()
            
            components.scheme   = "http"
            components.port     = 3002
            components.host     = "localhost"
            components.path     = "/reviews"
            
            return components
        }
        
        guard let reviewUrl = reviewURLComponents.url else {
            
            LoggerManager.shared.networkLogger.log(level: .error, "[Adidas] POST review url invalid \(reviewURLComponents, privacy: .private(mask: .hash))")
            
            return Just(["error":"Invalid url", "message": "Fail"])
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        guard let data = try? JSONEncoder().encode(review) else {
            
            LoggerManager.shared.networkLogger.log(level: .error, "[Adidas] POST review encoding failed \(review, privacy: .private(mask: .hash))")
            
            return Just(["error":"Invalid review", "message": "Fail to encode."])
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        var request: URLRequest = URLRequest(url: reviewUrl.appendingPathComponent(review.id))
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        request.httpMethod  = "POST"
        request.httpBody    = data
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                // make sure this JSON is in the format we expect
                guard let json = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String: Any] else {
                    return ["error":"Invalid data", "message": "Fail to decode."]
                }
                
                // try to read out a string array
                LoggerManager.shared.networkLogger.log(level: .error,"[Adidas] POST review error : \(json, privacy: .private(mask: .none))")
                
                guard
                    let httpResponse = result.response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    
                    return json
                }
                
                LoggerManager.shared.networkLogger.log(level: .default,"[Adidas] POST review response: \(httpResponse.statusCode, privacy: .public)")
                
                return json
            }
            .mapError { error -> NetworkError in
                
                LoggerManager.shared.networkLogger.log(level: .error,"[Adidas] POST review error response: \(error as NSError, privacy: .private)")
                
                switch error {
                case is EncodingError:  return NetworkError.encode(error as! EncodingError)
                case is URLError:       return NetworkError.url(error as! URLError)
                default:                return NetworkError.unknown(error)
                }
            }
            .retry(3)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
