//
//  ActivityOverlayTests.swift
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

class ActivityOverlayTests: XCTestCase {
	// MARK: Type properties
	private static let controllerNavID = "NavVC"
	private static let testString = "Some plain text"
	private static let testColor = UIColor.cyan
	private static let testFont = UIFont(name: "Avenir-Black", size: 15.0)!
	private static let testButtonTitle = "I'm a button"
	
	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: UIViewController!
	var overlay: TRIKActivityOverlay!
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Get test storyboard and view controllers for testing
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: ActivityOverlayTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: ActivityOverlayTests.controllerNavID) as? UINavigationController else {
			return
		}
		self.navVC = nvc
		
		guard let rvc = self.navVC.viewControllers.first else {
			return
		}
		self.controller = rvc
		// Preload controller's view
		_ = self.controller.view
		
		self.overlay = TRIKActivityOverlay(superview: self.controller.view, text: ActivityOverlayTests.testString)
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
		self.overlay.presentWithActivityIndicator()
		
		self.assertIndicatorVisibility()
	}
	
	func testPresentationWithActivityIndicatorAnimated() {
		let promise = expectation(description: "Animated presentation completed")
		self.overlay.presentWithActivityIndicator(animated: true) { (true) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			self.assertIndicatorVisibility()
		}
	}
	
	func testPresentationWithProgressBar() {
		self.overlay.presentWithProgressBar()
		
		self.assertProgressVisibility()
	}
	
	func testPresentationWithProgressBarAnimated() {
		let promise = expectation(description: "Animated presentation completed")
		self.overlay.presentWithProgressBar(animated: true) { (true) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			self.assertProgressVisibility()
		}
	}
	
	func testPresentActivityIndicator() {
		self.overlay.present()
		self.overlay.presentActivityIndicator()
		
		self.assertIndicatorVisibility()
	}
	
	func testPresentProgressBar() {
		self.overlay.present()
		self.overlay.presentProgressBar()
		
		self.assertProgressVisibility()
	}
	
	func testUpdatingProgress() {
		self.overlay.presentWithProgressBar()
		
		// Update to invalid negative value
		var progress: Float = -0.5
		self.overlay.updateProgress(progress)
		// Assert update failure and reset
		XCTAssertNotEqual(self.overlay.activityProgress.progress, progress, "\(progress) is an invalid value and should have been adjusted")
		XCTAssertEqual(self.overlay.activityProgress.progress, 0.0, "Progress should have been reset 0.0")
		
		// Update to valid value
		progress = 0.25
		self.overlay.updateProgress(progress)
		// Assert update success
		XCTAssertEqual(self.overlay.activityProgress.progress, progress, "Progress should have been updated to \(progress)")
		
		// Update to invalid value above 1.0
		progress = 1.3
		self.overlay.updateProgress(progress)
		// Assert update failure and reset
		XCTAssertNotEqual(self.overlay.activityProgress.progress, progress, "\(progress) is an invalid value and should have been adjusted")
		XCTAssertEqual(self.overlay.activityProgress.progress, 1.0, "Progress should have been adjusted to 1.0")
	}
	
	func testCustomizingButton() {
		self.overlay.present()
		
		// Setting button title
		self.overlay.setButtonTitle(ActivityOverlayTests.testButtonTitle)
		XCTAssertNotNil(self.overlay.button.title(for: .normal), "Overlay's button title should have been set")
		XCTAssertEqual(self.overlay.button.title(for: .normal)!, ActivityOverlayTests.testButtonTitle, "Overlay's button title does not match expected title")
		
		// Adding button target
		let selector = #selector(ActivityOverlayTests.buttonTargetMethod(_:))
		self.overlay.addButtonTarget(self, action: selector)
		XCTAssertNotNil(self.overlay.button.actions(forTarget: self, forControlEvent: .touchUpInside), "Overlay's button should have an action for specified target")
		
		// Removing button target
		self.overlay.removeButtonTarget(self, action: selector)
		XCTAssertNil(self.overlay.button.actions(forTarget: self, forControlEvent: .touchUpInside), "Overlay's button should not have an action for specified target anymore")
	}
	
	func testPresentAndDismissButton() {
		self.overlay.presentWithActivityIndicator()
		self.overlay.setButtonTitle(ActivityOverlayTests.testButtonTitle)
		
		self.overlay.presentButton()
		// Assert button is visible
		XCTAssertFalse(self.overlay.button.isHidden, "Overlay's button should be visible")
		
		self.overlay.dismissButton()
		// Assert button is not visible
		XCTAssertTrue(self.overlay.button.isHidden, "Overlay's button should not be visible")
	}
	
	func testSettingStyle() {
		self.overlay.presentWithActivityIndicator()
		
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
		XCTAssertFalse(self.overlay.isHidden, "Overlay should be visible")
		XCTAssertFalse(self.overlay.activityIndicator.isHidden, "Overlay should be visible")
		XCTAssertTrue(self.overlay.activityProgress.isHidden, "Overlay should be visible")
	}
	
	func assertProgressVisibility() {
		XCTAssertFalse(self.overlay.isHidden, "Overlay should be visible")
		XCTAssertFalse(self.overlay.activityProgress.isHidden, "Overlay should be visible")
		XCTAssertTrue(self.overlay.activityIndicator.isHidden, "Overlay should be visible")
	}
	
	@objc func buttonTargetMethod(_ sender: UIButton) {}
	
	func changeStyle(to newStyle: TRIKOverlay.Style, withAssertion assert: Bool) {
		let oldStyle = self.overlay.style
		self.overlay.setStyle(newStyle)
		
		if assert {
			// Assert style has been changed as expected
			XCTAssertNotEqual(self.overlay.style, oldStyle, "Overlay style does not match expected style")
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
				// Assert initialization options have been set correctly
				XCTAssertNotEqual(self.overlay.activityIndicator.color, color, "Overlay's activity color should have been adjusted for better visibility")
			}
		}
	}
	
}
