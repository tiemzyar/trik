//
//  StaticISSOverlayTests.swift
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
Unit test class for ``TRIKStaticImageSlideShowOverlay``.
*/
class StaticISSOverlayTests: ImageSlideShowOverlayTestBase {
}

// MARK: -
// MARK: Setup and tear-down
extension StaticISSOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension StaticISSOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKStaticImageSlideShowOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an image slide show overlay with a decoder")
	}
	
	func testInitImagePathsDefault() {
		self.overlay = TRIKStaticImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKStaticImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			// Assert initialization customized overlay as expected
			XCTAssertNotNil(overlay.imagePaths, "Overlay's image paths array should not be nil after initialization")
			XCTAssertNotNil(overlay.superview, "The overlay should have a superview after initialization")
			XCTAssertEqual(overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
			XCTAssertEqual(overlay.font, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
			XCTAssertEqual(overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
			XCTAssertEqual(overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
			XCTAssertEqual(overlay.buttonStyle, TRIKImageSlideShowOverlay.ButtonStyle.roundedRect, "Overlay button style does not match expected style")
			XCTAssertEqual(overlay.buttonAlpha, TRIKImageSlideShowOverlay.ButtonAlphaLevel.full, "Overlay button alpha level does not match expected level")
			XCTAssertTrue(overlay.isDismissable, "Overlay should be dismissable")
			XCTAssertTrue(overlay.pagingButtonsEnabled, "Overlay's paging buttons should be enabled")
			XCTAssertNil(overlay.delegate, "Overlay should not have a delegate")
		}
	}
	
	func testInitImagesDefault() {
		self.overlay = TRIKStaticImageSlideShowOverlay(images: self.images,
													   superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKStaticImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			// Assert initialization customized overlay as expected
			XCTAssertNotNil(overlay.images, "Overlay's images array should not be nil after initialization")
			XCTAssertNotNil(overlay.superview, "The overlay should have a superview after initialization")
			XCTAssertEqual(overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
			XCTAssertEqual(overlay.font, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
			XCTAssertEqual(overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
			XCTAssertEqual(overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
			XCTAssertEqual(overlay.buttonStyle, TRIKImageSlideShowOverlay.ButtonStyle.roundedRect, "Overlay button style does not match expected style")
			XCTAssertEqual(overlay.buttonAlpha, TRIKImageSlideShowOverlay.ButtonAlphaLevel.full, "Overlay button alpha level does not match expected level")
			XCTAssertTrue(overlay.isDismissable, "Overlay should be dismissable")
			XCTAssertTrue(overlay.pagingButtonsEnabled, "Overlay's paging buttons should be enabled")
			XCTAssertNil(overlay.delegate, "Overlay should not have a delegate")
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
		
		guard let overlay = self.overlay as? TRIKStaticImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		self.overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			// Assert current image indices are correct
			XCTAssertEqual(overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			overlay.displayPreviousImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 1, "Overlay's current image index does not match expected index")
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 2, "Overlay's current image index does not match expected index")
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 3, "Overlay's current image index does not match expected index")
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
		}
	}
	
	func testResettingImages() {
		self.overlay = TRIKStaticImageSlideShowOverlay(images: self.images,
													   superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKStaticImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			overlay.imagePaths = self.imagePaths
			overlay.images = self.images
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
			
			guard let overlay = self.overlay as? TRIKStaticImageSlideShowOverlay else {
				return XCTFail("Unexpected overlay type")
			}
			
			let promise = expectation(description: "Overlay presentation complete")
			overlay.present() { [unowned self] (_) in
				self.controller.view.setNeedsLayout()
				self.controller.view.layoutIfNeeded()
				promise.fulfill()
			}
			
			waitForExpectations(timeout: 5.0) { (_) in
				// Page to last image
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				overlay.displayNextImage()
				
				// Page back to first image
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
				overlay.displayPreviousImage()
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
		
		guard let overlay = self.overlay as? TRIKStaticImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			if assertOptions {
				// Assert initialization options have been set correctly
				XCTAssertEqual(overlay.style, style, "Overlay's style does not match expected style")
				XCTAssertEqual(overlay.buttonStyle, buttonStyle, "Overlay's button style does not match expected style")
				XCTAssertEqual(overlay.isDismissable, dismissButton, "Overlay's dismissable flag does not match expected value")
				XCTAssertEqual(overlay.pagingButtonsEnabled, pagingButtons, "Overlay's flag for enabled state of paging buttons does not match expected value")
				XCTAssertNotNil(overlay.delegate, "Overlay should have a delegate")
			}
		}
	}
}

extension StaticISSOverlayTests: TRIKImageSlideShowOverlayDelegate {
	func overlayDidDismiss(_ overlay: TRIKImageSlideShowOverlay) {
	}
}
