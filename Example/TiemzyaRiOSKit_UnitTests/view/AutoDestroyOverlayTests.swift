//
//  AutoDestroyOverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 01.02.18.
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
Unit test class for ``TRIKAutoDestroyOverlay``.
*/
class AutoDestroyOverlayTests: OverlayTestBase {
}

// MARK: -
// MARK: Setup and tear-down
extension AutoDestroyOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  text: AutoDestroyOverlayTests.testString)
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension AutoDestroyOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKAutoDestroyOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an auto destroy overlay with a decoder")
	}
	
	func testInitDefault() {
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertNotNil(self.overlay.label.text, "The overlay's label should have a text after initialization")
		XCTAssertEqual(self.overlay.label.text!, AutoDestroyOverlayTests.testString, "Text of overlay's label does not match expected text")
		XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay font does not match expected font")
		XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.bottom, "Overlay position does not match expected position")
	}
	
	func testInitWithOptions() {
		// Tap destruction active
		self.createOverlay(tappable: true, assertOptions: true)
		
		// Tap destruction inactive
		self.createOverlay(tappable: false, assertOptions: true)
	}
	
	func testAutoDestroy() {
		var delay = 0.75
		let timeoutDelta = 2.0
		var promise = expectation(description: "Overlay destroyed after \(delay) secs")
		
		self.createOverlay(withDestructionDelay: delay)
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			promise.fulfill()
		}
		waitForExpectations(timeout: delay + timeoutDelta) { [unowned self] (_) in
			// Assert overlay destruction
			XCTAssertNil(self.overlay.superview, "Overlay should not have a superview anymore")
		}
		
		delay = 2.0
		promise = expectation(description: "Overlay destroyed after \(delay) secs")
		
		self.createOverlay(withDestructionDelay: delay)
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			promise.fulfill()
		}
		waitForExpectations(timeout: delay + timeoutDelta) { [unowned self] (_) in
			// Assert overlay destruction
			XCTAssertNil(self.overlay.superview, "Overlay should not have a superview anymore")
		}
	}

	// MARK: Support methods
	func createOverlay(tappable: Bool, assertOptions assert: Bool) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  text: AutoDestroyOverlayTests.testString,
											  tapToDestroy: tappable)
		guard let adOverlay = self.overlay else {
			return
		}
		adOverlay.present(animated: true) { (_) in
			if assert {
				// Assert initialization options have been set correctly
				if tappable {
					XCTAssertNotNil(adOverlay.gestureRecognizers, "Overlay should have at least one gesture recognizer assigned")
				}
				else {
					XCTAssertNil(adOverlay.gestureRecognizers, "Overlay should not have any gesture recognizers assigned")
				}
			}
		}
	}
	
	func createOverlay(withDestructionDelay delay: Double) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  text: AutoDestroyOverlayTests.testString,
											  destroyAfter: delay)
		self.overlay.present(animated: true)
	}

}
