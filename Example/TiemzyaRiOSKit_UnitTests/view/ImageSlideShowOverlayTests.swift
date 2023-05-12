//
//  ImageSlideShowOverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 05.02.18.
//  Copyright © 2018-2023 tiemzyar.
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

/**
Unit test class for ``TRIKImageSlideShowOverlay``.
*/
class ImageSlideShowOverlayTests: ImageSlideShowOverlayTestBase {
}
	
// MARK: -
// MARK: Setup and tear-down
extension ImageSlideShowOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension ImageSlideShowOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKImageSlideShowOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an image slide show overlay with a decoder")
	}
	
	func testInitImagesDefault() {
		// Assert initialization customized overlay as expected
		self.overlay = TRIKImageSlideShowOverlay(imagePaths: self.imagePaths,
												 superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		XCTAssertNotNil(overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertEqual(overlay.font, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
		XCTAssertEqual(overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
		XCTAssertNil(overlay.delegate, "Overlay should not have a delegate")
	}
	
	func testSettingButtonStyle() {
		// Rounded rect
		var buttonStyle = TRIKImageSlideShowOverlay.ButtonStyle.roundedRect
		self.overlay = TRIKImageSlideShowOverlay(imagePaths: self.imagePaths,
												 superview: self.controller.view,
												 buttonStyle: buttonStyle)
		
		guard let overlay = self.overlay as? TRIKImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		// Assert button style has been set correctly
		XCTAssertEqual(overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
		
		// Circle
		buttonStyle = .circle
		overlay.buttonStyle = buttonStyle
		// Assert button style has been set correctly
		XCTAssertEqual(overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
		
		// Rect
		buttonStyle = .rect
		overlay.buttonStyle = buttonStyle
		// Assert button style has been set correctly
		XCTAssertEqual(overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
	}
	
	func testEmptyMethods() {
		self.overlay = TRIKImageSlideShowOverlay(imagePaths: self.imagePaths,
												 superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.presentWithImage(atIndex: 0)
		overlay.displayPreviousImage()
		overlay.displayNextImage()
		
		XCTAssertTrue(true, "Empty methods should have been called")
	}
	
	// MARK: Support methods
	
}
