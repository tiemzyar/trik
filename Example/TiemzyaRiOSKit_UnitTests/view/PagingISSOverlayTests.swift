//
//  PagingISSOverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 06.02.18.
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
Unit test class for ``TRIKPagingImageSlideShowOverlay``.
*/
class PagingISSOverlayTests: ImageSlideShowOverlayTestBase {
}

// MARK: -
// MARK: Setup and tear-down
extension PagingISSOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension PagingISSOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKPagingImageSlideShowOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an image slide show overlay with a decoder")
	}
	
	
	func testInitImagePathsDefault() {
		self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { [unowned self] (_) in
			self.controller.view.setNeedsLayout()
			self.controller.view.layoutIfNeeded()
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
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
			XCTAssertTrue(overlay.dualImageLayoutEnabled, "Overlay's dual image layout should be enabled")
			XCTAssertNil(overlay.delegate, "Overlay should not have a delegate")
		}
	}
	
	func testInitImagesDefault() {
		self.overlay = TRIKPagingImageSlideShowOverlay(images: self.images,
													   superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { [unowned self] (_) in
			self.controller.view.setNeedsLayout()
			self.controller.view.layoutIfNeeded()
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
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
			XCTAssertTrue(overlay.dualImageLayoutEnabled, "Overlay's dual image layout should be enabled")
			XCTAssertNil(overlay.delegate, "Overlay should not have a delegate")
		}
	}
	
	func testInitWithOptions() {
		// Dual image layout
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
		
		
		// No dual image layout
		// Style .white, all button styles
		self.createOverlay(withStyle: .white,
						   buttonStyle: .circle,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .white,
						   buttonStyle: .rect,
						   dualImageLayout: false)
		
		// Style .light, all button styles
		self.createOverlay(withStyle: .light,
						   buttonStyle: .circle,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .light,
						   buttonStyle: .roundedRect,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .light,
						   buttonStyle: .rect,
						   dualImageLayout: false)
		
		// Style .dark, all button styles
		self.createOverlay(withStyle: .dark,
						   buttonStyle: .circle,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .dark,
						   buttonStyle: .roundedRect,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .dark,
						   buttonStyle: .rect,
						   dualImageLayout: false)
		
		// Style .black, all button styles
		self.createOverlay(withStyle: .black,
						   buttonStyle: .circle,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .black,
						   buttonStyle: .roundedRect,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .black,
						   buttonStyle: .rect,
						   dualImageLayout: false)
		
		// Style .tiemzyar, all button styles
		self.createOverlay(withStyle: .tiemzyar,
						   buttonStyle: .circle,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .tiemzyar,
						   buttonStyle: .roundedRect,
						   dualImageLayout: false)
		self.createOverlay(withStyle: .tiemzyar,
						   buttonStyle: .rect,
						   dualImageLayout: false)
		
		// No dismiss button, no paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: false,
						   pagingButtons: false,
						   dualImageLayout: false)
		
		// Dismiss button, no paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: true,
						   pagingButtons: false,
						   dualImageLayout: false)
		
		// No dismiss button, paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: false,
						   pagingButtons: true,
						   dualImageLayout: false)
		
		// Dismiss button, paging buttons
		self.createOverlay(withStyle: .white,
						   buttonStyle: .roundedRect,
						   dismissButton: true,
						   pagingButtons: true,
						   dualImageLayout: false)
	}
	
	func testPagingFunctionalityNoDualLayout() {
		self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view,
													   dualImageLayout: false)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
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
	
	func testPagingFunctionalityDualLayoutOddImageCount() {
		self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view,
													   dualImageLayout: true)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			// Assert current image indices are correct
			XCTAssertEqual(overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 1, "Overlay's current image index does not match expected index")
			
			overlay.displayPreviousImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 1, "Overlay's current image index does not match expected index")
			
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 2, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 3, "Overlay's current image index does not match expected index")
			
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
			XCTAssertNil(overlay.currentImageIndices.second, "Overlay's current image index does not match expected index")
			
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
			XCTAssertNil(overlay.currentImageIndices.second, "Overlay's current image index does not match expected index")
		}
	}
	
	func testPagingFunctionalityDualLayoutEvenImageCount() {
		let bundle = Bundle(for: type(of: self))
		if let path = bundle.path(forResource: "image-1", ofType: TRIKConstant.FileManagement.FileExtension.jpg) {
			var paths = self.imagePaths
			paths.append(path)
			self.imagePathsStored = paths
		}
		self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view,
													   dualImageLayout: true)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { [unowned self] (_) in
			// Assert current image indices are correct
			XCTAssertEqual(overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 1, "Overlay's current image index does not match expected index")
			
			overlay.displayPreviousImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 0, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 1, "Overlay's current image index does not match expected index")
			
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 2, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 3, "Overlay's current image index does not match expected index")
			
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 5, "Overlay's current image index does not match expected index")
			
			overlay.displayNextImage()
			XCTAssertEqual(overlay.currentImageIndices.first, 4, "Overlay's current image index does not match expected index")
			XCTAssertEqual(overlay.currentImageIndices.second, 5, "Overlay's current image index does not match expected index")
			
			self.imagePathsStored?.removeLast()
		}
	}
	
	func testResettingImages() {
		self.overlay = TRIKPagingImageSlideShowOverlay(images: self.images,
													   superview: self.controller.view)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		let promise = expectation(description: "Overlay presentation complete")
		overlay.present() { (_) in
			promise.fulfill()
		}
		
		waitForExpectations(timeout: 5.0) { (_) in
			overlay.imagePaths = self.imagePaths
			self.waitWithoutBlockingMainThread(for: 1)
			overlay.images = self.images
		}
	}
	
	// MARK: Performance tests
	func testPresentationPerformanceImagePaths() {
		self.measure {
			self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePathsPerformance,
														   superview: self.controller.view)
			
			guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
				return XCTFail("Unexpected overlay type")
			}
			
			let promise = expectation(description: "Overlay presentation complete")
			overlay.present() { [unowned self] (_) in
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
			self.overlay = TRIKPagingImageSlideShowOverlay(images: self.imagesPerformance,
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
	
	func testPagingPerformanceDualLayout() {
		self.measure {
			self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePathsPerformance,
														   superview: self.controller.view)
			guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
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
			}
		}
	}
		
	func testPagingPerformanceNoDualLayout() {
		self.measure {
			self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePathsPerformance,
														   superview: self.controller.view,
														   dualImageLayout: false)
			
			guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
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
					   dualImageLayout: Bool = true,
					   assertOptions: Bool = true) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePaths,
													   superview: self.controller.view,
													   style: style,
													   buttonStyle: buttonStyle,
													   dismissButton: dismissButton,
													   pagingButtons: pagingButtons,
													   dualImageLayout: dualImageLayout,
													   delegate: self)
		
		guard let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay else {
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
				XCTAssertEqual(overlay.dualImageLayoutEnabled, dualImageLayout, "Overlay's flag for enabled state of dual image layout does not match expected value")
				XCTAssertNotNil(overlay.delegate, "Overlay should have a delegate")
			}
		}
	}
}

extension PagingISSOverlayTests: TRIKImageSlideShowOverlayDelegate {
	func overlayDidDismiss(_ overlay: TRIKImageSlideShowOverlay) {
	}
}
