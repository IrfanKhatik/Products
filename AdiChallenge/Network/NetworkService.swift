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
    case url(URLError)
    case decode(DecodingError)
    case encode(EncodingError)
    case unknown(Error)
    
    var description: String {
        switch self {
            case .url(let error):       return "Request to API Server failed \(error.localizedDescription)"
            case .decode(let error):    return "Failed parsing response from server \(error.localizedDescription)"
            case .encode(let error):    return "Failed to encode \(error.localizedDescription)"
            case .unknown(let error):   return "Unknown \(error.localizedDescription)"
        }
    }
}

final class NetworkService {
    
    var productURLComponents: URLComponents {
        var components = URLComponents()
        
        components.scheme   = "http"
        components.port     = 3001
        components.host     = "localhost"
        components.path     = "/product"
        
        return components
    }
    
    func fetchProducts() -> AnyPublisher<[Product], NetworkError> {
        let dummy: Product = Product(id: "", name: "", imgUrl: "", desc: "", price: 0, currency: "", reviews: [])
        guard let productUrl = productURLComponents.url else {
            
            LoggerManager.shared.networkLogger.log(level: .error, "[Adidas] GET Products url invalid \(self.productURLComponents, privacy: .private(mask: .hash))")
            
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
    
    var reviewURLComponents: URLComponents {
        var components = URLComponents()
        
        components.scheme   = "http"
        components.port     = 3002
        components.host     = "localhost"
        components.path     = "/reviews"
        
        return components
    }
    
    func submitReview(_ review: Review) -> AnyPublisher<Bool, NetworkError> {

        guard let reviewUrl = reviewURLComponents.url else {
            
            LoggerManager.shared.networkLogger.log(level: .error, "[Adidas] POST review url invalid \(self.reviewURLComponents, privacy: .private(mask: .hash))")
            
            return Just(false)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        }
        
        guard let data = try? JSONEncoder().encode(review) else {
            
            LoggerManager.shared.networkLogger.log(level: .error, "[Adidas] POST review encoding failed \(review, privacy: .private(mask: .hash))")
            
            return Just(false)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        }
        
        var request: URLRequest = URLRequest(url: reviewUrl.appendingPathComponent(review.id))
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        request.httpMethod  = "POST"
        request.httpBody    = data
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response in
                guard let httpResponse = response as? HTTPURLResponse,
                      201 == httpResponse.statusCode else {
                    return false
                }
                
                LoggerManager.shared.networkLogger.log(level: .default,"[Adidas] POST review response: 201")
                
                return true
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
