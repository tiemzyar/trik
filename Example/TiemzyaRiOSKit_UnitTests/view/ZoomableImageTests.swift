//
//  ZoomableImageTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 14.02.18.
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
Unit test class for ``TRIKZoomableImage``.
*/
class ZoomableImageTests: XCTestCase {
	// MARK: Type properties
	private static let controllerID = "SliderController"
	
	// MARK: Instance properties
	var controller: UIViewController!
	var zoomableImage: TRIKZoomableImage!
}

// MARK: -
// MARK: Setup and tear-down
extension ZoomableImageTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		// Get test storyboard and view controller for slider
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: ZoomableImageTests.self))
		self.controller = storyboard.instantiateViewController(withIdentifier: ZoomableImageTests.controllerID)
		
		// Preload controller's view
		_ = self.controller.view
	}
	
	override func tearDownWithError() throws {
		self.zoomableImage = nil
		self.controller = nil
		
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension ZoomableImageTests {
	func testInitCoder() {
		self.zoomableImage = TRIKZoomableImage(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.zoomableImage, "It should not be possible to initialize a zoomable image with a decoder")
    }
	
	func testInitFrame() {
		self.zoomableImage = TRIKZoomableImage(frame: CGRect.zero)
		
		// Assert initialization succeeded
		XCTAssertNotNil(self.zoomableImage, "Zoomable image should not be nil")
	}
	
	func testDisplayingImages() {
		// Big image dimensions
		let bundle = Bundle(for: type(of: self))
		guard let path1 = bundle.path(forResource: "image-1", ofType: TRIKConstant.FileManagement.FileExtension.jpg), let image1 = UIImage(contentsOfFile: path1) else {
			return
		}
		
		guard let view = self.controller.view else {
			return
		}
		
		self.zoomableImage = TRIKZoomableImage(frame: CGRect.zero)
		self.zoomableImage.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(self.zoomableImage)
		self.zoomableImage!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		self.zoomableImage!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		self.zoomableImage!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		self.zoomableImage!.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		
		self.zoomableImage.displayImage(image1)
		
		view.setNeedsLayout()
		view.layoutIfNeeded()
		
		// Assert image display succeeded
		XCTAssertNotNil(self.zoomableImage.imageView.image, "Zoomable image should contain an image")
		XCTAssertEqual(self.zoomableImage.imageView.image, image1, "Zoomable image's image does not match expected image")
		
		// Small image dimensions
		guard let path2 = bundle.path(forResource: "SmallImage", ofType: TRIKConstant.FileManagement.FileExtension.jpg), let image2 = UIImage(contentsOfFile: path2) else {
			return
		}
		self.zoomableImage.displayImage(image2)
		
		view.setNeedsLayout()
		view.layoutIfNeeded()
		
		// Assert image display succeeded
		XCTAssertNotNil(self.zoomableImage.imageView.image, "Zoomable image should contain an image")
		XCTAssertEqual(self.zoomableImage.imageView.image, image2, "Zoomable image's image does not match expected image")
	}
}
