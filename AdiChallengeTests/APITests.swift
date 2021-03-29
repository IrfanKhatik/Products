//
//  APITests.swift
//  AdiChallengeTests
//
//  Created by Irfan Khatik on 29/03/21.
//

import XCTest
import Combine
import OHHTTPStubsSwift
import OHHTTPStubs

@testable import AdiChallenge

class APITests: XCTestCase {
    var subscribers = Set<AnyCancellable>() //store ongoing subscribers (ongoing calls) here, for simplicities sake.
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        HTTPStubs.setEnabled(true)
        
        //NOTE: Subscribers are cancelled on deinit, so realistically the removeAll call is all that is needed to stop any ongoing calls.
        subscribers.forEach { $0.cancel() }
        subscribers.removeAll()
        
        HTTPStubs.onStubMissing { request in
            XCTFail("Missing stub for \(request)")
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        HTTPStubs.removeAllStubs()
    }
    
    // Test valid products response
    func testFetchProducts() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        stub(condition: isMethodGET() && isHost("localhost") && isPath("/product")) { request in
            // Stub it with our "products.json" stub file
            return HTTPStubsResponse(fileAtPath: OHPathForFile("products.json", type(of: self))!,
                                     statusCode: 200,
                                     headers: ["Accept":"application/json"])
        }
        
        let valueExpectation = self.expectation(description: "until api value is called")
        let completionExpectation = self.expectation(description: "until api value is called")
        
        var GETFinished = false
        NetworkService().fetchProducts()
            .sink(receiveCompletion: { completion in
                
                XCTAssertNotNil(completion)
                
                switch completion {
                
                case .finished: GETFinished = true
                    
                case .failure(.url( _)) : XCTFail("Call should succeed")
                case .failure(.decode( _)): XCTFail("Call should succeed")
                case .failure(.unknown( _)) : XCTFail("Call should succeed")
                case .failure(.encode( _)): XCTFail("Call should succeed")
                    
                }
                
                completionExpectation.fulfill()
            }, receiveValue: { products in
                
                XCTAssertNotNil(products)
                
                XCTAssertTrue(products.count == 16)
                
                valueExpectation.fulfill()
                
            }).store(in: &subscribers)
        
        wait(for: [completionExpectation, valueExpectation], timeout: 10, enforceOrder: false)
        
        XCTAssert(GETFinished)
    }
    
    // Test empty products response
    func testFetchProductsEmpty() throws {
        
        stub(condition: isMethodGET() && isHost("localhost") && isPath("/product")) { request in
            // Stub it with our "wsresponse.json" stub file
            return HTTPStubsResponse(fileAtPath: OHPathForFile("empty.json", type(of: self))!,
                                     statusCode: 200,
                                     headers: ["Accept":"application/json"])
        }
        
        let valueExpectation = self.expectation(description: "until api value is called")
        let completionExpectation = self.expectation(description: "until api value is called")
        
        var GETFinished = false
        NetworkService().fetchProducts()
            .sink(receiveCompletion: { completion in
                
                XCTAssertNotNil(completion)
                
                
                switch completion {
                
                case .finished: GETFinished = true
                    
                case .failure(.url( _)) : XCTFail("Call should succeed")
                case .failure(.decode( _)): XCTFail("Call should succeed")
                case .failure(.unknown( _)) : XCTFail("Call should succeed")
                case .failure(.encode( _)): XCTFail("Call should succeed")
                    
                }
                
                completionExpectation.fulfill()
                
            }, receiveValue: { products in
                
                XCTAssertNotNil(products)
                
                XCTAssertTrue(products.count == 0)
                
                valueExpectation.fulfill()
                
            }).store(in: &subscribers)
        
        wait(for: [completionExpectation, valueExpectation], timeout: 10, enforceOrder: false)
        
        XCTAssert(GETFinished)
    }
    
    // Test valid products response
    func testFetchProductsWithNoInternetConnection() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        stub(condition: isMethodGET() && isHost("localhost") && isPath("/product")) { request in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return HTTPStubsResponse(error:notConnectedError)
        }
        
        let completionExpectation = self.expectation(description: "until api completion is called")
        
        var GETFinished = false
        NetworkService().fetchProducts()
            .sink(receiveCompletion: { completion in
                
                XCTAssertNotNil(completion)
                
                switch completion {
                
                    case .finished: GETFinished = true
                
                    case .failure(.unknown(let error)) : XCTAssertNil(error)
                    
                    case .failure(.url(let error)): XCTAssertNotNil(error)
                    
                    case .failure(.decode(let error)): XCTAssertNotNil(error)

                    case .failure(.encode(let error)): XCTAssertNotNil(error)
                    
                }
                
                completionExpectation.fulfill()
                
            }, receiveValue: { products in
                
                XCTAssertNil(products)
                
                XCTAssertTrue(products.count == 0)
                
            }).store(in: &subscribers)
        
        wait(for: [completionExpectation], timeout: 10, enforceOrder: false)
        
        XCTAssertFalse(GETFinished)
    }
    
    // Test valid products response
    func testPOSTProductReview() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        stub(condition: isMethodPOST() && isHost("localhost")) { request in
            let jsonresponse = ["productId": "productId",
                                "locale": "en_US"]
            let data = try! JSONSerialization.data(withJSONObject: jsonresponse, options: .sortedKeys)
            return HTTPStubsResponse(data: data, statusCode: 201, headers: ["Content-Type":"application/json"])
        }
        
        let valueExpectation = self.expectation(description: "until api value is called")
        let completionExpectation = self.expectation(description: "until api value is called")
        
        var POSTFinished = false
        
        let review = Review(id: "productId", locale: "locale", rating: 5, text: "Awesome adidas product.")
        
        NetworkService().submitReview(review)
            .sink(receiveCompletion: { completion in
                
                XCTAssertNotNil(completion)
                
                switch completion {
                
                case .finished: POSTFinished = true
                    
                case .failure(.url( _)) : XCTFail("Call should succeed")
                case .failure(.decode( _)): XCTFail("Call should succeed")
                case .failure(.unknown( _)) : XCTFail("Call should succeed")
                case .failure(.encode( _)): XCTFail("Call should succeed")
                    
                }
                
                completionExpectation.fulfill()
            }, receiveValue: { result in
                
                XCTAssertNotNil(result)
                
                valueExpectation.fulfill()
                
            }).store(in: &subscribers)
        
        wait(for: [completionExpectation, valueExpectation], timeout: 10, enforceOrder: false)
        
        XCTAssert(POSTFinished)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
