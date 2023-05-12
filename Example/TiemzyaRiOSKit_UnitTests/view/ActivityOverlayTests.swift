//
//  ActivityOverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 31.01.18.
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

class ActivityOverlayTests: OverlayTestBase {
	// MARK: Type properties
	private static let testButtonTitle = "I'm a button"
}

// MARK: -
// MARK: Setup and tear-down
extension ActivityOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		self.overlay = TRIKActivityOverlay(superview: self.controller.view, text: ActivityOverlayTests.testString)
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension ActivityOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKActivityOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an activity overlay with a decoder")
	}
	
	func testInitDefault() {
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertNotNil(self.overlay.label.text, "The overlay's label should have a text after initialization")
		XCTAssertEqual(self.overlay.label.text!, ActivityOverlayTests.testString, "Text of overlay's label does not match expected text")
		XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay font does not match expected font")
		XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
	}
	
	func testPresentationWithActivityIndicator() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.presentWithActivityIndicator()
		
		self.assertIndicatorVisibility()
	}
	
	func testPresentationWithActivityIndicatorAnimated() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Animated presentation completed")
		overlay.presentWithActivityIndicator(animated: true) { (true) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			self.assertIndicatorVisibility()
		}
	}
	
	func testPresentationWithProgressBar() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.presentWithProgressBar()
		
		self.assertProgressVisibility()
	}
	
	func testPresentationWithProgressBarAnimated() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Animated presentation completed")
		overlay.presentWithProgressBar(animated: true) { (true) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			self.assertProgressVisibility()
		}
	}
	
	func testPresentActivityIndicator() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.present()
		overlay.presentActivityIndicator()
		
		self.assertIndicatorVisibility()
	}
	
	func testPresentProgressBar() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.present()
		overlay.presentProgressBar()
		
		self.assertProgressVisibility()
	}
	
	func testUpdatingProgress() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.presentWithProgressBar()
		
		// Update to invalid negative value
		var progress: Float = -0.5
		overlay.updateProgress(progress)
		// Assert update failure and reset
		XCTAssertNotEqual(overlay.activityProgress.progress, progress, "\(progress) is an invalid value and should have been adjusted")
		XCTAssertEqual(overlay.activityProgress.progress, 0.0, "Progress should have been reset 0.0")
		
		// Update to valid value
		progress = 0.25
		overlay.updateProgress(progress)
		// Assert update success
		XCTAssertEqual(overlay.activityProgress.progress, progress, "Progress should have been updated to \(progress)")
		
		// Update to invalid value above 1.0
		progress = 1.3
		overlay.updateProgress(progress)
		// Assert update failure and reset
		XCTAssertNotEqual(overlay.activityProgress.progress, progress, "\(progress) is an invalid value and should have been adjusted")
		XCTAssertEqual(overlay.activityProgress.progress, 1.0, "Progress should have been adjusted to 1.0")
	}
	
	func testCustomizingButton() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.present()
		
		// Setting button title
		overlay.setButtonTitle(ActivityOverlayTests.testButtonTitle)
		XCTAssertNotNil(overlay.button.title(for: .normal), "Overlay's button title should have been set")
		XCTAssertEqual(overlay.button.title(for: .normal)!, ActivityOverlayTests.testButtonTitle, "Overlay's button title does not match expected title")
		
		// Adding button target
		let selector = #selector(ActivityOverlayTests.buttonTargetMethod(_:))
		overlay.addButtonTarget(self, action: selector)
		XCTAssertNotNil(overlay.button.actions(forTarget: self, forControlEvent: .touchUpInside), "Overlay's button should have an action for specified target")
		
		// Removing button target
		overlay.removeButtonTarget(self, action: selector)
		XCTAssertNil(overlay.button.actions(forTarget: self, forControlEvent: .touchUpInside), "Overlay's button should not have an action for specified target anymore")
	}
	
	func testPresentAndDismissButton() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.presentWithActivityIndicator()
		overlay.setButtonTitle(ActivityOverlayTests.testButtonTitle)
		
		overlay.presentButton()
		// Assert button is visible
		XCTAssertFalse(overlay.button.isHidden, "Overlay's button should be visible")
		
		overlay.dismissButton()
		// Assert button is not visible
		XCTAssertTrue(overlay.button.isHidden, "Overlay's button should not be visible")
	}
	
	func testSettingStyle() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		overlay.presentWithActivityIndicator()
		
		self.changeStyle(to: .light, withAssertion: true)
		self.changeStyle(to: .dark, withAssertion: true)
		self.changeStyle(to: .black, withAssertion: true)
		self.changeStyle(to: .tiemzyar, withAssertion: true)
		self.changeStyle(to: .white, withAssertion: true)
	}
	
	func testStyleDependentActivityColorAdjustment() {
		// Adjustments for style .white
		var style: TRIKOverlay.Style = .white
		var color = TRIKConstant.Color.white
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		color = TRIKConstant.Color.Grey.dark
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		
		// Adjustments for style .light
		style = .light
		color = TRIKConstant.Color.Grey.light
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		color = TRIKConstant.Color.Grey.dark
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		
		// Adjustments for style .dark
		style = .dark
		color = TRIKConstant.Color.Grey.light
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		color = TRIKConstant.Color.Grey.dark
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		
		// Adjustments for style .black
		style = .black
		color = TRIKConstant.Color.Grey.light
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		color = TRIKConstant.Color.black
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
		
		// Adjustments for style .tiemzyar
		style = .tiemzyar
		color = TRIKConstant.Color.Blue.tiemzyar
		self.createOverlay(withStyle: style,
						   activityColor: color,
						   assertAdjustment: true)
	}
	
	// MARK: Support methods
	func assertIndicatorVisibility() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		XCTAssertFalse(overlay.isHidden, "Overlay should be visible")
		XCTAssertFalse(overlay.activityIndicator.isHidden, "Overlay should be visible")
		XCTAssertTrue(overlay.activityProgress.isHidden, "Overlay should be visible")
	}
	
	func assertProgressVisibility() {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		XCTAssertFalse(overlay.isHidden, "Overlay should be visible")
		XCTAssertFalse(overlay.activityProgress.isHidden, "Overlay should be visible")
		XCTAssertTrue(overlay.activityIndicator.isHidden, "Overlay should be visible")
	}
	
	@objc func buttonTargetMethod(_ sender: UIButton) {}
	
	func changeStyle(to newStyle: TRIKOverlay.Style, withAssertion assert: Bool) {
		guard let overlay = self.overlay as? TRIKActivityOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let oldStyle = overlay.style
		overlay.setStyle(newStyle)
		
		if assert {
			// Assert style has been changed as expected
			XCTAssertNotEqual(overlay.style, oldStyle, "Overlay style does not match expected style")
		}
	}
	
	func createOverlay(withStyle style: TRIKOverlay.Style,
					   activityColor color: UIColor,
					   assertAdjustment assert: Bool) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKActivityOverlay(superview: self.controller.view,
										   text: ActivityOverlayTests.testString,
										   style: style,
										   activityColor: color)
		self.overlay.present(animated: false) { [unowned self] (_) in
			if assert {
				guard let overlay = self.overlay as? TRIKActivityOverlay else {
					return XCTFail("Unexpected overlay type")
				}
				
				// Assert initialization options have been set correctly
				XCTAssertNotEqual(overlay.activityIndicator.color, color, "Overlay's activity color should have been adjusted for better visibility")
			}
		}
	}
}
