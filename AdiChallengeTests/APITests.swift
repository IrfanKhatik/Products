//
//  APITests.swift
//  AdiChallengeTests
//
//  Created by Irfan Khatik on 27/03/21.
//

import XCTest
import Combine

import AdiChallenge

class APITests: XCTestCase {

    var subscribers = Set<AnyCancellable>() //store ongoing subscribers (ongoing calls) here, for simplicities sake.
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // NOTE: Subscribers are cancelled on deinit, so realistically the removeAll call is all that is needed to stop any ongoing calls.
        subscribers.forEach { $0.cancel() }
        subscribers.removeAll()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAPIThrowsErrorWhenGETtingWithInvalidURL() throws {
        var productURLComponents: URLComponents {
            var components = URLComponents()
            
            components.scheme = "http"
            components.port = 3001
            components.host = "localhost"
            components.path = "product"
            
            return components
        }
        
        var GETFinished = false
        
        
//        NetworkService().get(endpoint: "notreal")
//            .sink(receiveCompletion: { (completion) in
//                GETFinished = true
//                switch completion {
//                case .finished: XCTFail("Should have thrown error")
//                case .failure(let error):
//                    XCTAssertEqual((error as? API.URLError), API.URLError.unableToCreateURL)
//                }
//            }, receiveValue: { _ in })
//            .store(in: &subscribers)
//        waitUntil(GETFinished)
//        XCTAssert(GETFinished)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
