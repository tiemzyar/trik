//
//  ImageSlideShowOverlayTests.swift
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

class ImageSlideShowOverlayTests: XCTestCase {
	// MARK: Type properties
	private static let controllerNavID = "NavVC"
	
	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: UIViewController!
	var overlay: TRIKImageSlideShowOverlay!
	private var imagePathsStored: [String]?
	var imagePaths: [String] {
		if self.imagePathsStored == nil {
			var paths: [String] = []
			for number in 1...10 {
				let bundle = Bundle(for: type(of: self))
				if let path = bundle.path(forResource: "image-\(number)", ofType: TRIKConstant.FileManagement.FileExtension.jpg) {
					paths.append(path)
				}
			}
			self.imagePathsStored = paths
		}
		
		return self.imagePathsStored!
	}
	
	private var imagesStored: [UIImage]?
	var images: [UIImage] {
		if self.imagesStored == nil {
			var imgs: [UIImage] = []
			for path in self.imagePaths {
				if let img = UIImage(contentsOfFile: path) {
					imgs.append(img)
				}
			}
			self.imagesStored = imgs
		}
		
		return self.imagesStored!
	}
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Get test storyboard and view controllers for testing
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: ImageSlideShowOverlayTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: ImageSlideShowOverlayTests.controllerNavID) as? UINavigationController else {
			return
		}
		self.navVC = nvc
		
		guard let rvc = self.navVC.viewControllers.first else {
			return
		}
		self.controller = rvc
		// Preload controller's view
		_ = self.controller.view
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
		self.imagesStored = nil
		self.imagePathsStored = nil
		
		super.tearDown()
	}
	
	// MARK: Test methods
	func testInitCoder() {
		self.overlay = TRIKImageSlideShowOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an image slide show overlay with a decoder")
	}
	
	func testInitImagesDefault() {
		// Assert initialization customized overlay as expected
		self.overlay = TRIKImageSlideShowOverlay(imagePaths: self.imagePaths,
												 superview: self.controller.view)
		XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
		XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
		XCTAssertNil(self.overlay.delegate, "Overlay should not have a delegate")
	}
	
	func testSettingButtonStyle() {
		// Rounded rect
		var buttonStyle = TRIKImageSlideShowOverlay.ButtonStyle.roundedRect
		self.overlay = TRIKImageSlideShowOverlay(imagePaths: self.imagePaths,
												 superview: self.controller.view,
												 buttonStyle: buttonStyle)
		// Assert button style has been set correctly
		XCTAssertEqual(self.overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
		
		// Circle
		buttonStyle = .circle
		self.overlay.buttonStyle = buttonStyle
		// Assert button style has been set correctly
		XCTAssertEqual(self.overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
		
		// Rect
		buttonStyle = .rect
		self.overlay.buttonStyle = buttonStyle
		// Assert button style has been set correctly
		XCTAssertEqual(self.overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
	}
	
	func testEmptyMethods() {
		self.overlay = TRIKImageSlideShowOverlay(imagePaths: self.imagePaths,
												 superview: self.controller.view)
		self.overlay.presentWithImage(atIndex: 0)
		self.overlay.displayPreviousImage()
		self.overlay.displayNextImage()
		
		XCTAssertTrue(true, "Empty methods should have been called")
	}
	
	// MARK: Support methods
	
}
