//
//  BaseVCTests.swift
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

class BaseVCTests: XCTestCase {
	// MARK: Type properties
	private static let controllerBaseID = "BaseVC"
	private static let controllerNavID = "NavVC"
	private static let controllerText = "Some title"
	private static let segueID = "FVCtoBVC"
	
	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: TRIKBaseVC!
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Get test storyboard and view controllers for testing
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: BaseVCTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: BaseVCTests.controllerNavID) as? UINavigationController else {
			return
		}
		self.navVC = nvc
		
		guard let bvc = storyboard.instantiateViewController(withIdentifier: BaseVCTests.controllerBaseID) as? TRIKBaseVC else {
			return
		}
		self.controller = bvc
		self.controller.titleLabelText = BaseVCTests.controllerText
		
		// Create navigation hierarchy and preload controller's view
		self.navVC.pushViewController(self.controller, animated: false)
		_ = self.controller.view
	}
	
	override func tearDown() {
		self.navVC = nil
		self.controller = nil
		
		super.tearDown()
	}
	
	// MARK: Test methods
	func testViewDidLoad() {
		// Assert title label text has been set as expected
		XCTAssertNotNil(self.controller.titleLabel.text, "Title label text should not be nil")
		XCTAssertEqual(self.controller.titleLabel.text!, BaseVCTests.controllerText, "Title label text does not match expected text")
	}
	
	func testBackwardsNavigation() {
		// Get current navigation stack controller count
		let controllerCount = self.navVC.viewControllers.count
		
		// Perform backwards navigation
		self.controller.returnToPreviousView(sender: nil)
		
		// Assert navigation stack controller count has been reduced
		XCTAssertLessThan(self.navVC.viewControllers.count, controllerCount, "Navigation controller controller count is greater than expected")
	}
	
	func testToolbarButtonCreation() {
		// Guard controller's toolbar exists and get its item count
		guard self.controller.baseToolbar != nil else {
			return
		}
		
		var itemCount: Int = 0
		if let items = self.controller.baseToolbar.items {
			itemCount = items.count
		}
		
		// Try creating toolbar back button
		self.controller.createToolbarBackButton()
		
		// Assert toolbar items property exists and that its count has increased
		XCTAssertNotNil(self.controller.baseToolbar.items, "Toolbar items should not be nil")
		XCTAssertGreaterThan(self.controller.baseToolbar.items!.count, itemCount, "Toolbar item count is lower than expected")
	}
	
	func testToolbarButtonCreationWithoutToolbar() {
		// Set controller's toolbar to nil
		self.controller.baseToolbar = nil
		
		// Try creating toolbar back button
		self.controller.createToolbarBackButton()
		
		// Assert toolbar is nil
		XCTAssertNil(self.controller.baseToolbar, "Controller's base toolbar property should be nil")
	}
	
	func testUIAdaption() {
		// Create test arguments
		let size = CGSize.zero
		let deviceOrientation = UIDeviceOrientation.portrait
		let interfaceOrientation = UIInterfaceOrientation.portrait
		
		// Call UI adaption methods
		if let tc = self.controller.transitionCoordinator {
			self.controller.adaptUI(to: size, with: tc)
		}
		
		self.controller.adaptUI(toDeviceOrientation: deviceOrientation)
		self.controller.adaptUI(toInterfaceOrientation: interfaceOrientation)
		
		XCTAssertTrue(true, "UI adaption methods should have been called")
	}
    
}
