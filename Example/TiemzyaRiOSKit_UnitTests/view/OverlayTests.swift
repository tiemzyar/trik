//
//  OverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 31.01.18.
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

class OverlayTests: XCTestCase {
	// MARK: Type properties
	private static let controllerNavID = "NavVC"
	private static let testString = "Some plain text"
	private static let testFont = UIFont(name: "Avenir-Black", size: 15.0)!
	
	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: UIViewController!
	var overlay: TRIKOverlay!
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Get test storyboard and view controllers for testing
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: OverlayTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: OverlayTests.controllerNavID) as? UINavigationController else {
			return
		}
		self.navVC = nvc
		
		guard let rvc = self.navVC.viewControllers.first else {
			return
		}
		self.controller = rvc
		// Preload controller's view
		_ = self.controller.view
		
		self.overlay = TRIKOverlay(superview: self.controller.view, text: OverlayTests.testString)
	}
	
	override func tearDown() {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
			self.overlay = nil
		}
		self.controller = nil
		self.navVC = nil
		
		super.tearDown()
	}
	
	// MARK: Test methods
	func testInitCoder() {
		self.overlay = TRIKOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an overlay with a decoder")
	}
	
	func testInitDefault() {
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertNotNil(self.overlay.label.text, "The overlay's label should have a text after initialization")
		XCTAssertEqual(self.overlay.label.text!, OverlayTests.testString, "Text of overlay's label does not match expected text")
		XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay font does not match expected font")
		XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
	}
	
	func testInitWithOptions() {
		// All styles, position .top
		self.createOverlay(withStyle: .white, position: .top, assertOptions: true)
		self.createOverlay(withStyle: .light, position: .top, assertOptions: true)
		self.createOverlay(withStyle: .dark, position: .top, assertOptions: true)
		self.createOverlay(withStyle: .black, position: .top, assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar, position: .top, assertOptions: true)
		
		// All styles, position .center
		self.createOverlay(withStyle: .white, position: .center, assertOptions: true)
		self.createOverlay(withStyle: .light, position: .center, assertOptions: true)
		self.createOverlay(withStyle: .dark, position: .center, assertOptions: true)
		self.createOverlay(withStyle: .black, position: .center, assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar, position: .center, assertOptions: true)
		
		// All styles, position .bottom
		self.createOverlay(withStyle: .white, position: .bottom, assertOptions: true)
		self.createOverlay(withStyle: .light, position: .bottom, assertOptions: true)
		self.createOverlay(withStyle: .dark, position: .bottom, assertOptions: true)
		self.createOverlay(withStyle: .black, position: .bottom, assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar, position: .bottom, assertOptions: true)
		
		// All styles, full screen
		self.createOverlay(withStyle: .white, position: .full, assertOptions: true)
		self.createOverlay(withStyle: .light, position: .full, assertOptions: true)
		self.createOverlay(withStyle: .dark, position: .full, assertOptions: true)
		self.createOverlay(withStyle: .black, position: .full, assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar, position: .full, assertOptions: true)
	}
	
	func testPresentationAndDismissal() {
		self.overlay.present()
		// Assert overlay is visible
		XCTAssertFalse(self.overlay.isHidden, "Overlay should be visible")
		
		self.overlay.dismiss()
		// Assert overlay is not visible
		XCTAssertTrue(self.overlay.isHidden, "Overlay should not be visible")
	}
	
	func testPresentationAndDismissalAnimated() {
		let promisePresent = expectation(description: "Overlay presentation completed")
		self.overlay.present(animated: true) { (_) in
			promisePresent.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			// Assert overlay is visible
			XCTAssertFalse(self.overlay.isHidden, "Overlay should be visible")
		}
		
		let promiseDismiss = expectation(description: "Overlay dismissal completed")
		self.overlay.dismiss(animated: true) { (_) in
			promiseDismiss.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			// Assert overlay is not visible
			XCTAssertTrue(self.overlay.isHidden, "Overlay should not be visible")
		}
	}
	
	func testSettingText() {
		self.overlay.setText(OverlayTests.testString)
		// Assert text has been set correctly
		XCTAssertNotNil(self.overlay.label.text, "Overlay's text should have been set")
		XCTAssertEqual(self.overlay.label.text, OverlayTests.testString, "Text of overlay's label does not match expected text")
	}
	
	// MARK: Support methods
	func createOverlay(withStyle style: TRIKOverlay.Style,
					   position: TRIKOverlay.Position,
					   assertOptions: Bool) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKOverlay(superview: self.controller.view,
								   text: OverlayTests.testString,
								   font: OverlayTests.testFont,
								   style: style,
								   position: position)
		
		self.overlay.present(animated: false) { [unowned self] (_) in
			if assertOptions {
				// Assert initialization options have been set correctly
				XCTAssertEqual(self.overlay.style, style, "Overlay style does not match expected style")
				XCTAssertEqual(self.overlay.position, position, "Overlay position does not match expected position")
			}
		}
	}
}
