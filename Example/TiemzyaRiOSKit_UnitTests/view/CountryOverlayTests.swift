//
//  CountryOverlayTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 01.02.18.
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
Unit test class for ``TRIKCountryOverlay``.
*/
class CountryOverlayTests: OverlayTestBase {
	// MARK: Instance properties
	var activeView: UIView?
}

// MARK: -
// MARK: Setup and tear-down
extension CountryOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		self.overlay = TRIKCountryOverlay(superview: self.controller.view)
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Tests
extension CountryOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKCountryOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize a country overlay with a decoder")
	}
	
	func testInitDefault() {
		guard let overlay = self.overlay as? TRIKCountryOverlay else {
			return XCTFail("Unexpected overlay type")
		}
		
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertEqual(overlay.fontHeader, TRIKCountryOverlay.defaultFontHeader, "Overlay header font does not match expected font")
		XCTAssertEqual(overlay.fontContent, TRIKOverlay.defaultFont, "Overlay content font does not match expected font")
		XCTAssertEqual(overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(overlay.position, TRIKOverlay.Position.center, "Overlay position does not match expected position")
		XCTAssertEqual(overlay.selectedLocale, TRIKCountryOverlay.Locale.local, "Overlay locale does not match expected locale")
		XCTAssertTrue(overlay.localizationEnabled, "Overlay localization should be enabled")
		XCTAssertNil(overlay.delegate, "Overlay should not have a delegate")
	}
	
	func testInitWithOptions() {
		// Localization enabled, all locales
		self.createOverlay(withStyle: .white,
						   locale: .local,
						   localizationEnabled: true,
						   assertOptions: true)
		self.createOverlay(withStyle: .white,
						   locale: .english,
						   localizationEnabled: true,
						   assertOptions: true)
		self.createOverlay(withStyle: .white,
						   locale: .german,
						   localizationEnabled: true,
						   assertOptions: true)
		
		// Localization disabled, all locales
		self.createOverlay(withStyle: .white,
						   locale: .local,
						   localizationEnabled: false,
						   assertOptions: true)
		self.createOverlay(withStyle: .white,
						   locale: .english,
						   localizationEnabled: false,
						   assertOptions: true)
		self.createOverlay(withStyle: .white,
						   locale: .german,
						   localizationEnabled: false,
						   assertOptions: true)
		
		// Localization enabled, all styles
		self.createOverlay(withStyle: .white,
						   locale: .local,
						   localizationEnabled: true,
						   assertOptions: true)
		self.createOverlay(withStyle: .light,
						   locale: .local,
						   localizationEnabled: true,
						   assertOptions: true)
		self.createOverlay(withStyle: .dark,
						   locale: .local,
						   localizationEnabled: true,
						   assertOptions: true)
		self.createOverlay(withStyle: .black,
						   locale: .local,
						   localizationEnabled: true,
						   assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar,
						   locale: .local,
						   localizationEnabled: true,
						   assertOptions: true)
		
		
		// Localization disabled, all styles
		self.createOverlay(withStyle: .white,
						   locale: .local,
						   localizationEnabled: false,
						   assertOptions: true)
		self.createOverlay(withStyle: .light,
						   locale: .local,
						   localizationEnabled: false,
						   assertOptions: true)
		self.createOverlay(withStyle: .dark,
						   locale: .local,
						   localizationEnabled: false,
						   assertOptions: true)
		self.createOverlay(withStyle: .black,
						   locale: .local,
						   localizationEnabled: false,
						   assertOptions: true)
		self.createOverlay(withStyle: .tiemzyar,
						   locale: .local,
						   localizationEnabled: false,
						   assertOptions: true)
		
	}
	
	func testCountryFileValidityCheck() {
		let bundle = Bundle(for: type(of: self))
		var testFileURL = URL(fileURLWithPath: TRIKUtil.FileManagement.getApplicationDocumentsDirectoryURL().path)
		testFileURL.appendPathComponent("NoPlist")
		testFileURL.appendPathExtension(TRIKConstant.FileManagement.FileExtension.plist)
		
		// Test non-existent file
		TRIKCountryOverlay.testPath = testFileURL.path
		var result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		// Test wrong file format
		let data = Data()
		FileManager.default.createFile(atPath: testFileURL.path,
									   contents: data,
									   attributes: nil)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		if FileManager.default.fileExists(atPath: testFileURL.path) {
			do {
				try FileManager.default.removeItem(at: testFileURL)
			} catch {}
		}
		
		// Test incorrect file structure
		TRIKCountryOverlay.testPath = bundle.path(forResource: "CountriesIncorrectStructure", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		// Test empty countries array
		TRIKCountryOverlay.testPath = bundle.path(forResource: "CountriesEmpty", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		// Test wrong country root key
		TRIKCountryOverlay.testPath = bundle.path(forResource: "CountriesWrongRootKey", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		// Test wrong country names key
		TRIKCountryOverlay.testPath = bundle.path(forResource: "CountriesWrongNamesKey", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		// Test empty country names key
		TRIKCountryOverlay.testPath = bundle.path(forResource: "CountriesEmptyNamesKey", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for countries file should not be valid")
		
		// Test valid external countries file
		TRIKCountryOverlay.testPath = bundle.path(forResource: "CountriesValidExternal", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		// Assert file is valid
		XCTAssertTrue(result.valid, "Validity check result for countries file should be valid")
		
		// Test valid internal countries file
		TRIKCountryOverlay.testPath = nil
		result = TRIKCountryOverlay.checkCountriesFileValidity()
		// Assert file is valid
		XCTAssertTrue(result.valid, "Validity check result for countries file should be valid")
	}

	// MARK: Support methods
	func createOverlay(withStyle style: TRIKOverlay.Style,
					   locale: TRIKCountryOverlay.Locale,
					   localizationEnabled: Bool,
					   assertOptions: Bool) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKCountryOverlay(superview: self.controller.view,
										  headerFont: CountryOverlayTests.testFontHeader,
										  contentFont: CountryOverlayTests.testFontContent,
										  style: style,
										  position: .center,
										  locale: locale,
										  localizationEnabled: localizationEnabled,
										  delegate: self)
		
		self.overlay.present(animated: false) { (_) in
			guard let overlay = self.overlay as? TRIKCountryOverlay else {
				return XCTFail("Unexpected overlay type")
			}
			
			overlay.countryTable.reloadData()
			self.controller.view.layoutIfNeeded()
			
			if assertOptions {
				// Assert initialization options have been set correctly
				XCTAssertEqual(overlay.style, style, "Overlay's style does not match expected style")
				XCTAssertEqual(overlay.selectedLocale, locale, "Overlay's selected locale does not match expected locale")
				XCTAssertEqual(overlay.localizationEnabled, localizationEnabled, "Overlay's localization flag does not match expected value")
			}
		}
	}
}

extension CountryOverlayTests: TRIKCountryOverlayDelegate {
	func countryOverlay(_ overlay: TRIKCountryOverlay,
						didSelectCountry country: (names: [String : String], codeA2: String, codeA3: String, codeNum: String)) {
	}
}
