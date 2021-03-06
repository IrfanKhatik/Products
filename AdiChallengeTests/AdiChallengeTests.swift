//
//  AdiChallengeTests.swift
//  AdiChallengeTests
//
//  Created by Irfan Khatik on 29/03/21.
//

import XCTest

@testable import AdiChallenge

class AdiChallengeTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPriceWithCurrency() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: "Adidas T 200",
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: 200,
                              currency: "nl_NL",
                              reviews: [],
                              discount: 10)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.formattedPrice
        
        XCTAssertGreaterThanOrEqual(price.count, 3)
        
        XCTAssertEqual(price, "€ 200,00")
    }
    
    func testPriceWithoutCurrency() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: "Adidas T 200",
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: 50,
                              currency: "",
                              reviews: [],
                              discount: 15)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.formattedPrice
        
        XCTAssertEqual(price.count, 0)
        
        XCTAssertEqual(price, "")
    }
    
    func testPriceZeroWithCurrency() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: "Adidas T 200",
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: 0.0,
                              currency: "nl_NL",
                              reviews: [],
                              discount: 5.0)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.formattedPrice
        
        XCTAssertEqual(price, "€ 0,00")
    }
    
    func testWithoutPriceAndCurrency() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: "Adidas T 200",
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: 0.0,
                              currency: "",
                              reviews: [],
                              discount: 20.0)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.formattedPrice
        
        XCTAssertEqual(price, "")
    }
    
    func testNegativePriceWithCurrency() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: "Adidas T 200",
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: -100.0,
                              currency: "nl_NL",
                              reviews: [],
                              discount: 0.0)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.formattedPrice
        
        XCTAssertEqual(price, "")
    }
    
    func testPriceWithUnknownCurrency() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: "Adidas T 200",
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: 100,
                              currency: "un_XY",
                              reviews: [],
                              discount: 15.0)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.formattedPrice
        
        XCTAssertEqual(price, "")
    }
    
    func testProductWithNilName() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let product = Product(id: "ProductId",
                              name: nil,
                              imgUrl: "https://www.adidas.com/t200.jpg",
                              desc: "Athele shoes for swift runners.",
                              price: -100.0,
                              currency: "nl_NL",
                              reviews: [],
                              discount: 30)
        
        let productViewModel = ProductViewModel(product)
        
        let price = productViewModel.name
        
        XCTAssertEqual(price, "")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
