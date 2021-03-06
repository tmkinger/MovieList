//
//  MovieListUITests.swift
//  MovieListUITests
//
//  Created by Tarun Mukesh Kinger on 15/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import XCTest

class MovieListUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testMoviesNavigation() {
        let app = XCUIApplication()
        app.tables.cells.containing(.staticText, identifier:"Avengers:Age of Ultron ").staticTexts["Action, Adventure, Sci-Fi "].tap()
        app.navigationBars["Avengers:Age of Ultron"].buttons["Movies List"].tap()
    }
}
