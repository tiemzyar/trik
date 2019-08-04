//
//  TiemzyaRiOSKit_UITests.swift
//  TiemzyaRiOSKit_UITests
//
//  Created by tiemzyar on 16.01.18.
//  Copyright © 2018 tiemzyar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest

class TiemzyaRiOSKit_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
//		let app = XCUIApplication()
//		app.buttons["Auto Destroy Overlay"].tap()
//
//		let overlayHinzufGenButton = app/*@START_MENU_TOKEN@*/.buttons["Overlay hinzufügen"]/*[[".scrollViews.buttons[\"Overlay hinzufügen\"]",".buttons[\"Overlay hinzufügen\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//		overlayHinzufGenButton.tap()
//
//		let elementsQuery = app.scrollViews.otherElements
//		elementsQuery/*@START_MENU_TOKEN@*/.buttons["light"]/*[[".segmentedControls.buttons[\"light\"]",".buttons[\"light\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//		overlayHinzufGenButton.tap()
//		elementsQuery/*@START_MENU_TOKEN@*/.buttons["dark"]/*[[".segmentedControls.buttons[\"dark\"]",".buttons[\"dark\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//		overlayHinzufGenButton.tap()

    }
    
}
