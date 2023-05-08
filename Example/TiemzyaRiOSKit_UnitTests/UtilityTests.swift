//
//  UtilTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 12.02.18.
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
import CoreData

@testable import TiemzyaRiOSKit

class UtilityTests: CommonTestBase {
	// MARK: Type properties


	// MARK: Instance properties


	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()


	}

	override func tearDown() {


		super.tearDown()
	}

	// MARK: Test methods
    func testDeveloperLogging() {
		// Simple string logging
		devLog("Some string")
		// Logging using string interpolation
		let value = 1.0
		devLog("Some string containing a value of \(value)")
		let multilineString = """
			This is
				a string
					spanning over
						multiple lines
			"""
		devLog(multilineString)
		// Object logging
		devLog(NSObject())
		
		// Specifying file, function and line
		devLog("Some string", "SomeFile.file", "someFunction()", 100)
		
		// Invalid file
		devLog("Some string", "Not a file #!?<>__:$&")
    }
	
	func testErrorLogging() {
		// Simple error logging
		var error = NSError(domain: "SomeErrorDomain", code: 3072, userInfo: nil)
		logErrors(containedIn: error, message: "Here's your error:")
		
		// Nested error logging
		let errors: [Error] = [Error1(),
							   Error2(),
							   Error3(),
							   Error4()]
		let userInfo: [String: Any] = [NSLocalizedDescriptionKey: "An error with details",
									   NSDetailedErrorsKey: errors]
		error = NSError(domain: "SomeErrorDomain", code: 3072, userInfo: userInfo)
		logErrors(containedIn: error, message: "Here's your error(s):")
	}
	
	func testFetchingApplicationDocumentsDirectory() {
		let dir1 = TRIKUtil.FileManagement.getApplicationDocumentsDirectoryURL().path
		let dir2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		// Assert fetched directory is correct
		XCTAssertEqual(dir1, dir2, "Fetched directory does not match expected directory")
	}
	
	func testTrimmingFileExtensions() {
		let fileExtension = ".format"
		let fileWithoutExtension = "SomeFile"
		let fileWithExtension = "SomeFile\(fileExtension)"
		let fileWithPeriodsNoExtension = "Some.Periodic.File"
		let fileWithPeriodsAndExtension = "\(fileWithPeriodsNoExtension)\(fileExtension)"
		
		// No extension to strip
		var fileName = TRIKUtil.FileManagement.trimFileExtension(fromFile: fileWithoutExtension)
		XCTAssertEqual(fileName, fileWithoutExtension, "Stripped file name does not match expected name")
		
		// Extension to strip, no extra periods in file name
		fileName = TRIKUtil.FileManagement.trimFileExtension(fromFile: fileWithExtension)
		XCTAssertEqual(fileName, fileWithoutExtension, "Stripped file name does not match expected name")
		
		// Extension to strip, plus periods in file name
		fileName = TRIKUtil.FileManagement.trimFileExtension(fromFile: fileWithPeriodsAndExtension)
		XCTAssertEqual(fileName, fileWithPeriodsNoExtension, "Stripped file name does not match expected name")
	}
	
	func testLanguageFileValidityCheck() {
		let bundle = Bundle(for: type(of: self))
		var testFileURL = URL(fileURLWithPath: TRIKUtil.FileManagement.getApplicationDocumentsDirectoryURL().path)
		testFileURL.appendPathComponent("NoPlist")
		testFileURL.appendPathExtension(TRIKConstant.FileManagement.FileExtension.plist)
		
		// Test non-existent file
		TRIKUtil.Language.languageFileTestPath = testFileURL.path
		var result = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for languages file should not be valid")
		
		// Test wrong file format
		let data = Data()
		FileManager.default.createFile(atPath: testFileURL.path,
									   contents: data,
									   attributes: nil)
		result = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for languages file should not be valid")
		
		if FileManager.default.fileExists(atPath: testFileURL.path) {
			do {
				try FileManager.default.removeItem(at: testFileURL)
			} catch {}
		}
		
		// Test incorrect file structure
		TRIKUtil.Language.languageFileTestPath = bundle.path(forResource: "LanguagesIncorrectStructure", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for languages file should not be valid")
		
		// Test empty languages array
		TRIKUtil.Language.languageFileTestPath = bundle.path(forResource: "LanguagesEmpty", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for languages file should not be valid")
		
		// Test wrong language key
		TRIKUtil.Language.languageFileTestPath = bundle.path(forResource: "LanguagesWrongKey", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		// Assert file is invalid
		XCTAssertFalse(result.valid, "Validity check result for languages file should not be valid")
		
		// Test valid external languages file
		TRIKUtil.Language.languageFileTestPath = bundle.path(forResource: "LanguagesValidExternal", ofType: TRIKConstant.FileManagement.FileExtension.plist)
		result = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		// Assert file is valid
		XCTAssertTrue(result.valid, "Validity check result for languages file should be valid")
		
		// Test TRIK framework internal languages file
		TRIKUtil.Language.languageFileTestPath = nil
		result = TRIKUtil.Language.checkLanguagesFileValidity()
		// Assert file is valid
		XCTAssertTrue(result.valid, "Validity check result for languages file should be valid")
	}
	
	func testReachabilityCheck() {
		_ = TRIKUtil.Network.sharedReachabilityManager
		TRIKUtil.Network.startMonitoringReachability()
		
		let checkExpectation = expectation(description: "Expecting reachability check completion")
		TRIKUtil.Network.reachabilityCheck { availabilityStatus in
			XCTAssertTrue(availabilityStatus.isNetworkAvailable, "As long as the testing computer is connected to the internet, isReachable should be true")
			XCTAssertFalse(availabilityStatus.isCellularNetwork)
			
			checkExpectation.fulfill()
		}
		
		self.waitForExpectations()
		
	}
	
	// MARK: Support methods

}

class Error1: Error {
	var localizedDescription: String
	
	init() {
		self.localizedDescription = "This is a type 1 error"
	}
}

class Error2: Error {
	var localizedDescription: String
	
	init() {
		self.localizedDescription = "This is a type 2 error"
	}
}

class Error3: LocalizedError {
	var localizedDescription: String
	var errorDescription: String?
	var failureReason: String?
	var helpAnchor: String?
	var recoverySuggestion: String?
	
	init() {
		self.localizedDescription = "This is a type 3 error"
	}
}

class Error4: LocalizedError {
	var localizedDescription: String
	var errorDescription: String?
	var failureReason: String?
	var helpAnchor: String?
	var recoverySuggestion: String?
	
	init() {
		self.localizedDescription = "This is a type 4 error"
		self.errorDescription = "The error, described in utmost detail"
		self.failureReason = "Failed for no reason whatsoever ..."
		self.helpAnchor = "There is no help!"
		self.recoverySuggestion = "Try a hard reset, maybe?"
	}
}
