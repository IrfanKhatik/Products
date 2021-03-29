//
//  AdiChallengeUITests.swift
//  AdiChallengeUITests
//
//  Created by Irfan Khatik on 29/03/21.
//

import XCTest

class AdiChallengeUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func addScreenshot(screenshot: XCUIScreenshot) {
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        
        add(attachment)
    }
    
    func testSearchTextField() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let enterSearchTextField = app.textFields["enterSearchTextField"]
        
        XCTAssertNotNil(enterSearchTextField)
        
        XCTAssert(enterSearchTextField.exists)
        
        if let placeholderValue = enterSearchTextField.placeholderValue {
            XCTAssertEqual(placeholderValue, "Search your adidas products", "Search textfield placeholderValue is not correct")
        }
        
        addScreenshot(screenshot: app.windows.firstMatch.screenshot())
        
        enterSearchTextField.tap()
        enterSearchTextField.typeText("Adidas")
        addScreenshot(screenshot: app.windows.firstMatch.screenshot())
        
        XCTAssertEqual( enterSearchTextField.value as! String, "Adidas", "Search textfield has proper value")
        
        addScreenshot(screenshot: app.windows.firstMatch.screenshot())
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
