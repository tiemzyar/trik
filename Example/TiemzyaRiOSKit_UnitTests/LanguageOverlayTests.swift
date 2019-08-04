//
//  LanguageOverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 05.02.18.
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

class LanguageOverlayTests: XCTestCase {
	// MARK: Type properties
	private static let controllerNavID = "NavVC"
	private static let testFontContent = UIFont(name: "Avenir-Black", size: 15.0)!
	private static let testFontHeader = UIFont(name: "Avenir-Heavy", size: 18.0)!
	private static let testFontTitle = UIFont(name: "Avenir-Heavy", size: 20.0)!
	private static let testString = "Some arbitrary text"
	
	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: UIViewController!
	var overlay: TRIKLanguageOverlay!
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Get test storyboard and view controllers for testing
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: LanguageOverlayTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: LanguageOverlayTests.controllerNavID) as? UINavigationController else {
			return
		}
		self.navVC = nvc
		
		guard let rvc = self.navVC.viewControllers.first else {
			return
		}
		self.controller = rvc
		// Preload controller's view
		_ = self.controller.view
		
		self.overlay = TRIKLanguageOverlay(superview: self.controller.view,
										   text: LanguageOverlayTests.testString)
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
		self.overlay = TRIKLanguageOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize a language overlay with a decoder")
	}
	
	func testInitDefault() {
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertEqual(self.overlay.font, TRIKLanguageOverlay.defaultFontTitle, "Overlay title font does not match expected font")
		XCTAssertEqual(self.overlay.fontHeader, TRIKLanguageOverlay.defaultFontHeader, "Overlay header font does not match expected font")
		XCTAssertEqual(self.overlay.fontContent, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
		XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
		XCTAssertEqual(self.overlay.fallbackLanguage, TRIKConstant.Language.Code.english, "Overlay fallback language does not match expected language")
		XCTAssertNil(self.overlay.delegate, "Overlay should not have a delegate")
	}
	
	func testInitWithOptions() {
		// All styles
		self.createOverlay(withStyle: .white,
						   assertOptions: true)
		self.createOverlay(withStyle: .light,
						   assertOptions: true)
		self.createOverlay(withStyle: .dark,
						   assertOptions: true)
		self.createOverlay(withStyle: .black,
						   assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar,
						   assertOptions: true)
		
	}
	
	// MARK: Support methods
	func createOverlay(withStyle style: TRIKOverlay.Style,
					   assertOptions: Bool) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKLanguageOverlay(superview: self.controller.view,
										   text: LanguageOverlayTests.testString,
										   style: style,
										   delegate: self)
		
		self.overlay.present(animated: false) { (_) in
			self.overlay.languageTable.reloadData()
			self.controller.view.layoutIfNeeded()
			
			if assertOptions {
				// Assert initialization options have been set correctly
				XCTAssertEqual(self.overlay.style, style, "Overlay's style does not match expected style")
				XCTAssertNotNil(self.overlay.delegate, "Overlay's delegate should not be nil")
			}
		}
	}
}

extension LanguageOverlayTests: TRIKLanguageOverlayDelegate {
	func overlay(_ overlay: TRIKLanguageOverlay, didSelectLanguage language: String) {
	}
	
	func overlayDidCancel(_ overlay: TRIKLanguageOverlay) {
	}
}
