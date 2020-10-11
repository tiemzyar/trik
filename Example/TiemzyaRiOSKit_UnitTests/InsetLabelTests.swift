//
//  InsetLabelTests.swift
//  TiemzyaRiOSKit_Tests
//
//  Created by tiemzyar on 11.01.18.
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

class InsetLabelTests: XCTestCase {
	// MARK: Type properties
	private static let controllerID = "InsetLabelController"
	private static let labelTag = 101
	private static let insetsIB = UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
	private static let insetsCode = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
	private static let testText = "Some text for testing"
	
	// MARK: Instance properties
	var controller: UIViewController!
	var insets: UIEdgeInsets!
	var label: TRIKInsetLabel!
	
	// MARK: Setup and tear-down
    override func setUp() {
        super.setUp()
		
		// Get test storyboard and view controller for inset label
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: InsetLabelTests.self))
		self.controller = storyboard.instantiateViewController(withIdentifier: InsetLabelTests.controllerID)
		
		_ = self.controller.view
		
		
		self.insets = InsetLabelTests.insetsCode
    }
    
    override func tearDown() {
        self.label = nil
		self.insets = nil
		self.controller = nil
		
        super.tearDown()
    }
	
	// MARK: Test methods
	func testInitCoder() {
		if let controllerLabel = self.controller.view.viewWithTag(InsetLabelTests.labelTag) as? TRIKInsetLabel {
			self.label = controllerLabel
		}
		
		// Assert label exists
		XCTAssertNotNil(self.label, "Label should not be nil")
		
		// Assert label has custom text insets as set in storyboard
		XCTAssertEqual(InsetLabelTests.insetsIB, self.label.textInsets, "Label insets do not match expected insets")
	}
    
	func testInitFrameAndInsets() {
		// Initialize label with custom insets
		let frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
		self.label = TRIKInsetLabel(frame: frame, textInsets: self.insets)
		
		// Assert label insets match expected insets
		XCTAssertEqual(self.label.textInsets, self.insets, "Label insets do not match expected insets")
	}
	
	func testSettingInsets() {
		// Initialize label with default insets (0,0,0,0)
		self.label = TRIKInsetLabel(frame: CGRect.zero)
		
		// Assert label insets do not match test class insets
		XCTAssertNotEqual(self.label.textInsets, self.insets, "Label insets should not match preset insets")
		
		// Set label insets
		self.label.textInsets = self.insets
		
		// Assert label insets match test class insets
		XCTAssertEqual(self.label.textInsets, self.insets, "Label insets do not match expected insets")
	}
	
	func testSettingsInsetsIndividually() {
		// Initialize label with default insets (0,0,0,0)
		self.label = TRIKInsetLabel(frame: CGRect.zero)
		
		let bottomInset: CGFloat = 5.0
		let leftInset: CGFloat = 10.0
		let rightInset: CGFloat = 15.0
		let topInset: CGFloat = 20.0
		
		// Set custom text insets individually and assert they did get set correctly
		self.label.bottomTextInset = bottomInset
		XCTAssertEqual(self.label.bottomTextInset, bottomInset, "Bottom text inset did not set correctly")
		self.label.leftTextInset = leftInset
		XCTAssertEqual(self.label.leftTextInset, leftInset, "Left text inset did not set correctly")
		self.label.rightTextInset = rightInset
		XCTAssertEqual(self.label.rightTextInset, rightInset, "Right text inset did not set correctly")
		self.label.topTextInset = topInset
		XCTAssertEqual(self.label.topTextInset, topInset, "Top text inset did not set correctly")
	}
	
	func testSettingText() {
		// Label initialized from storyboard
		if let controllerLabel = self.controller.view.viewWithTag(InsetLabelTests.labelTag) as? TRIKInsetLabel {
			self.label = controllerLabel
			self.label.text = InsetLabelTests.testText
			self.label.setNeedsLayout()
			self.label.layoutIfNeeded()
		}
		
		// Assert label exists
		XCTAssertNotNil(self.label, "Label should not be nil")
		
		// Assert label text did get set
		XCTAssertNotNil(self.label.text, "Label text should not be nil")
		XCTAssertEqual(self.label.text, InsetLabelTests.testText, "Label text does not match expected test")
		
		
		// Initialize label with custom insets and set text
		self.label = TRIKInsetLabel(frame: CGRect.zero, textInsets: self.insets)
		self.label.text = InsetLabelTests.testText
		
		// Assert label text did get set
		XCTAssertNotNil(self.label.text, "Label text should not be nil")
		XCTAssertEqual(self.label.text, InsetLabelTests.testText, "Label text does not match expected test")
	}
}
