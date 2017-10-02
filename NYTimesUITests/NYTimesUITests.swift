//
//  NYTimesUITests.swift
//  NYTimesUITests
//
//  Created by Home on 25/9/17.
//  Copyright © 2017 Home. All rights reserved.
//

import XCTest

class NYTimesUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // Test case: tap on UICollectionViewCell
        let cells = XCUIApplication().collectionViews.cells
        for cell in cells.allElementsBoundByIndex {
            cell.tap()
            //cell.backButton.tap()
        }
        
        // Test case: test when editing UISearchBar
        /*let app = XCUIApplication()
        app.searchFields["searchBar"].tap()
        app.searchFields["searchBar"].typeText("something")*/
        
        let firstCell = app.collectionViews.cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 3))
        start.press(forDuration: 0, thenDragTo: finish)
        
        app.searchFields.element.tap()
        app.searchFields.element.typeText("search text")
        
    }
}
