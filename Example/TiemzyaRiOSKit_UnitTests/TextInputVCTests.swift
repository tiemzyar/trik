//
//  TextInputVCTests.swift
//  TiemzyaRiOSKit_Tests
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

import UIKit
import XCTest

@testable import TiemzyaRiOSKit

class TextInputVCTests: XCTestCase {
	// MARK: Type properties
	private static let controllerID = "TextInputVC"
	private static let testBorderWidth: CGFloat = 2.0
	private static let testColor = UIColor.green
	private static let testLabelHeight: CGFloat = 25.0
	private static let testTextFieldTag = 101
	private static let testString = "Some text"
	private static let textFieldCount = 3
	private static let textFieldCountNoRecursion = 1
	
	// MARK: Instance properties
	var controller: TRIKTextInputVC!
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Get test storyboard and view controller for inset label
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: TextInputVCTests.self))
		guard let tevc = storyboard.instantiateViewController(withIdentifier: TextInputVCTests.controllerID) as? TRIKTextInputVC else {
			return
		}
		self.controller = tevc
		
		// Preload controller's view
		_ = self.controller.view
	}
	
	override func tearDown() {
		self.controller = nil
		
		super.tearDown()
	}
	
	// MARK: Test methods
	func testViewDidLoad() {
		// Assert controller's first subview property is set
		XCTAssertNotNil(self.controller.firstSubview, "First subview should not be nil")
	}
	
	func testSettingTintColor() {
		// Set tint color of text fields that are direct subviews of the controller's first subview
		let count = self.controller.setTintColor(TextInputVCTests.testColor, forTextFieldsInView: self.controller.firstSubview)
		
		// Assert correct count of adjusted text fields
		XCTAssertEqual(count, TextInputVCTests.textFieldCountNoRecursion, "Count of adjusted text fields is wrong")
	}
	
	func testSettingTintColorRecursively() {
		// Set tint color of text fields in the complete subview hierarchy of the controller's first subview
		let count = self.controller.setTintColor(TextInputVCTests.testColor, forTextFieldsInView: self.controller.firstSubview, recursive: true)
		
		// Assert correct count of adjusted text fields
		XCTAssertEqual(count, TextInputVCTests.textFieldCount, "Count of adapted text fields is wrong")
	}
	
	func testLabelCreation() {
		// Create flexible width label
		let label = self.controller.labelOfFlexibleWidth(withString: TextInputVCTests.testString, fixedHeight: TextInputVCTests.testLabelHeight)
		
		// Assert correct label text
		XCTAssertEqual(label.text!, TextInputVCTests.testString, "Label text does not match expected text")
	}
	
	func testAddingAndRemovingBorder() {
		// Add border
		self.controller.addBorder(withColor: TextInputVCTests.testColor, andWidth: TextInputVCTests.testBorderWidth, toView: self.controller.titleLabel)
		
		// Assert border has been added
		XCTAssertEqual(UIColor(cgColor: self.controller.titleLabel.layer.borderColor!), TextInputVCTests.testColor, "View border color does not match expected color")
		XCTAssertEqual(self.controller.titleLabel.layer.borderWidth, TextInputVCTests.testBorderWidth, "View border width does not match expected width")
		
		// Remove border
		self.controller.removeBorder(fromView: self.controller.titleLabel)
		
		// Assert border has been removed
		XCTAssertEqual(self.controller.titleLabel.layer.borderWidth, 0.0, "View border should be zero")
	}
	
	func testAddingBorderNoView() {
		self.controller.addBorder()
		
		XCTAssertTrue(true, "Nothing should have happend here")
	}
	
	func testRemovingBorderWhenNotSet() {
		self.controller.removeBorder(fromView: self.controller.titleLabel)
		
		XCTAssertTrue(true, "Nothing should have happend here")
	}
}
