//
//  AdiChallengeTests.swift
//  AdiChallengeTests
//
//  Created by Irfan Khatik on 29/03/21.
//

import XCTest
import Combine

@testable import AdiChallenge

class AdiChallengeTests: XCTestCase {
    //store ongoing subscribers (ongoing calls) here, for simplicities sake.
    var subscribers = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //NOTE: Subscribers are cancelled on deinit, so realistically the removeAll call is all that is needed to stop any ongoing calls.
        subscribers.forEach { $0.cancel() }
        subscribers.removeAll()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
<<<<<<< HEAD

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        NetworkService().fetchProducts()
=======
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //NetworkService().fetchProducts()
>>>>>>> Added Swift Package Manager for OHHTTPStubs
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
