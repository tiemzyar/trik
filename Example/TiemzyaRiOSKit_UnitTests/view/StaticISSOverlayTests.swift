//
//  StaticISSOverlayTests.swift
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

class StaticISSOverlayTests: XCTestCase {
	// MARK: Type properties
	private static let controllerNavID = "NavVC"
	
	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: UIViewController!
	var overlay: TRIKStaticImageSlideShowOverlay!
	private var imagePathsStored: [String]?
	var imagePaths: [String] {
		if self.imagePathsStored == nil {
			var paths: [String] = []
			for number in 1...5 {
				let bundle = Bundle(for: type(of: self))
				if let path = bundle.path(forResource: "image-\(number)", ofType: TRIKConstant.FileManagement.FileExtension.jpg) {
					paths.append(path)
				}
			}
			self.imagePathsStored = paths
		}
		
		return self.imagePathsStored!
	}
	
	private var imagePathsStoredPerformance: [String]?
	var imagePathsPerformance: [String] {
		if self.imagePathsStored == nil {
			var paths: [String] = []
			for number in 1...54 {
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
	
	private var imagesStoredPerformance: [UIImage]?
	var imagesPerformance: [UIImage] {
		if self.imagesStored == nil {
			var imgs: [UIImage] = []
			for path in self.imagePathsPerformance {
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
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: StaticISSOverlayTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: StaticISSOverlayTests.controllerNavID) as? UINavigationController else {
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
		self.overlay = TRIKStaticImageSlideShowOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an image slide show overlay with a decoder")
	}
	
	func testInitImagePathsDefault() {
		self.overlay = TRIKStaticImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view)
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			// Assert initialization customized overlay as expected
			XCTAssertNotNil(self.overlay.imagePaths, "Overlay's image paths array should not be nil after initialization")
			XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
			XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
			XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
			XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
			XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
			XCTAssertEqual(self.overlay.buttonStyle, TRIKImageSlideShowOverlay.ButtonStyle.roundedRect, "Overlay button style does not match expected style")
			XCTAssertEqual(self.overlay.buttonAlpha, TRIKImageSlideShowOverlay.ButtonAlphaLevel.full, "Overlay button alpha level does not match expected level")
			XCTAssertTrue(self.overlay.isDismissable, "Overlay should be dismissable")
			XCTAssertTrue(self.overlay.pagingButtonsEnabled, "Overlay's paging buttons should be enabled")
			XCTAssertNil(self.overlay.delegate, "Overlay should not have a delegate")
		}
	}
	
	func testInitImagesDefault() {
		self.overlay = TRIKStaticImageSlideShowOverlay(images: self.images,
													   superview: self.controller.view)
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			// Assert initialization customized overlay as expected
			XCTAssertNotNil(self.overlay.images, "Overlay's images array should not be nil after initialization")
			XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
			XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
			XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
			XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
			XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
			XCTAssertEqual(self.overlay.buttonStyle, TRIKImageSlideShowOverlay.ButtonStyle.roundedRect, "Overlay button style does not match expected style")
			XCTAssertEqual(self.overlay.buttonAlpha, TRIKImageSlideShowOverlay.ButtonAlphaLevel.full, "Overlay button alpha level does not match expected level")
			XCTAssertTrue(self.overlay.isDismissable, "Overlay should be dismissable")
			XCTAssertTrue(self.overlay.pagingButtonsEnabled, "Overlay's paging buttons should be enabled")
			XCTAssertNil(self.overlay.delegate, "Overlay should not have a delegate")
		}
	}
	
	func testInitWithOptions() {
		// Style .white, all button styles
		self.createOverlay(withStyle: .white,
						   buttonStyle: .circle)
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect)
		self.createOverlay(withStyle: .white,
						   buttonStyle: .rect)
		
		// Style .light, all button styles
		self.createOverlay(withStyle: .light,
						   buttonStyle: .circle)
		self.createOverlay(withStyle: .light,
						   buttonStyle: .roundedRect)
		self.createOverlay(withStyle: .light,
						   buttonStyle: .rect)
		
		// Style .dark, all button styles
		self.createOverlay(withStyle: .dark,
						   buttonStyle: .circle)
		self.createOverlay(withStyle: .dark,
						   buttonStyle: .roundedRect)
		self.createOverlay(withStyle: .dark,
						   buttonStyle: .rect)
		
		// Style .black, all button styles
		self.createOverlay(withStyle: .black,
						   buttonStyle: .circle)
		self.createOverlay(withStyle: .black,
						   buttonStyle: .roundedRect)
		self.createOverlay(withStyle: .black,
						   buttonStyle: .rect)
		
		// Style .tiemzyar, all button styles
		self.createOverlay(withStyle: .tiemzyar,
						   buttonStyle: .circle)
		self.createOverlay(withStyle: .tiemzyar,
						   buttonStyle: .roundedRect)
		self.createOverlay(withStyle: .tiemzyar,
						   buttonStyle: .rect)
		
		// No dismiss button, no paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: false,
						   pagingButtons: false)
		
		// Dismiss button, no paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: true,
						   pagingButtons: false)
		
		// No dismiss button, paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: false,
						   pagingButtons: true)
		
		// Dismiss button, paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: true,
						   pagingButtons: true)
	}
	
	func testPagingFunctionality() {
		self.overlay = TRIKStaticImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view)
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			// Assert current image indices are correct
			XCTAssertEqual(self.overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			self.overlay.displayPreviousImage()
			XCTAssertEqual(self.overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			self.overlay.displayNextImage()
			XCTAssertEqual(self.overlay.currentImageIndices.first, 1, "Overlay's current image index does not match expected index")
			self.overlay.displayNextImage()
			XCTAssertEqual(self.overlay.currentImageIndices.first, 2, "Overlay's current image index does not match expected index")
			self.overlay.displayNextImage()
			XCTAssertEqual(self.overlay.currentImageIndices.first, 3, "Overlay's current image index does not match expected index")
			self.overlay.displayNextImage()
			XCTAssertEqual(self.overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
			self.overlay.displayNextImage()
			XCTAssertEqual(self.overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
		}
	}
	
	func testResettingImages() {
		self.overlay = TRIKStaticImageSlideShowOverlay(images: self.images,
													   superview: self.controller.view)
		
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			self.overlay.imagePaths = self.imagePaths
			self.overlay.images = self.images
		}
	}
	
	// MARK: Performance test methods
	func testPresentationPerformanceImagePaths() {
		self.measure {
			self.overlay = TRIKStaticImageSlideShowOverlay(imagePaths: self.imagePathsPerformance,
														   superview: self.controller.view)
			let promise = expectation(description: "Overlay presentation complete")
			self.overlay.present() { [unowned self] (_) in
				self.controller.view.setNeedsLayout()
				self.controller.view.layoutIfNeeded()
				promise.fulfill()
			}
			
			waitForExpectations(timeout: 5.0) { (_) in
			}
		}
	}
	
	func testPresentationPerformanceImages() {
		self.measure {
			self.overlay = TRIKStaticImageSlideShowOverlay(images: self.imagesPerformance,
														   superview: self.controller.view)
			let promise = expectation(description: "Overlay presentation complete")
			self.overlay.present() { [unowned self] (_) in
				self.controller.view.setNeedsLayout()
				self.controller.view.layoutIfNeeded()
				promise.fulfill()
			}
			
			waitForExpectations(timeout: 5.0) { (_) in
			}
		}
	}
	
	func testPagingPerformance() {
		self.measure {
			self.overlay = TRIKStaticImageSlideShowOverlay(imagePaths: self.imagePathsPerformance,
														   superview: self.controller.view)
			let promise = expectation(description: "Overlay presentation complete")
			self.overlay.present() { [unowned self] (_) in
				self.controller.view.setNeedsLayout()
				self.controller.view.layoutIfNeeded()
				promise.fulfill()
			}
			
			waitForExpectations(timeout: 5.0) { [unowned self] (_) in
				// Page to last image
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				self.overlay.displayNextImage()
				
				// Page back to first image
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
				self.overlay.displayPreviousImage()
			}
		}
	}
	
	// MARK: Support methods
	func createOverlay(withStyle style: TRIKOverlay.Style,
					   buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle,
					   dismissButton: Bool = true,
					   pagingButtons: Bool = true,
					   assertOptions: Bool = true) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKStaticImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view,
													   style: style,
													   buttonStyle: buttonStyle,
													   dismissButton: dismissButton,
													   pagingButtons: pagingButtons,
													   delegate: self)
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			if assertOptions {
				// Assert initialization options have been set correctly
				XCTAssertEqual(self.overlay.style, style, "Overlay's style does not match expected style")
				XCTAssertEqual(self.overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
				XCTAssertEqual(self.overlay.isDismissable, dismissButton, "Overlay's dismissable flag does not match expected value")
				XCTAssertEqual(self.overlay.pagingButtonsEnabled, pagingButtons, "Overlay's flag for enabled state of paging buttons does not match expected value")
				XCTAssertNotNil(self.overlay.delegate, "Overlay should have a delegate")
			}
		}
	}
}

extension StaticISSOverlayTests: TRIKImageSlideShowOverlayDelegate {
	func overlayDidDismiss(_ overlay: TRIKImageSlideShowOverlay) {
	}
}
