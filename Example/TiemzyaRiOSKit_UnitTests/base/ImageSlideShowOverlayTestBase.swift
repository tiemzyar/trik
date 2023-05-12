//
//  ImageSlideShowOverlayTestBase.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 11.05.23.
//  Copyright © 2023 tiemzyar. All rights reserved.
//

import UIKit
import XCTest

@testable import TiemzyaRiOSKit

/**
Base class providing common functionality for image slide show overlay test classes.
*/
class ImageSlideShowOverlayTestBase: OverlayTestBase {
	// MARK: Instance properties
	var imagePathsStored: [String]?
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
	
	var imagePathsStoredPerformance: [String]?
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
	
	var imagesStored: [UIImage]?
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
	
	var imagesStoredPerformance: [UIImage]?
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
}

// MARK: -
// MARK: Setup and tear-down
extension ImageSlideShowOverlayTestBase {
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		self.imagesStored = nil
		self.imagePathsStored = nil
		self.imagesStoredPerformance = nil
		self.imagePathsStoredPerformance = nil
		
		try super.tearDownWithError()
	}
}
