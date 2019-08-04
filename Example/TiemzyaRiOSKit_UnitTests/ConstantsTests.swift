//
//  ConstantsTests.swift
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

@testable import TiemzyaRiOSKit

class ConstantsTests: XCTestCase {
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
    func testColors() {
		// Blue colors
		var color = TRIKConstant.Color.Blue.light
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.Blue.medium
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.Blue.tiemzyar
		XCTAssertNotNil(color, "Color should not be nil")
		
		// Grey colors
		color = TRIKConstant.Color.Grey.dark
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.Grey.light
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.Grey.medium
		XCTAssertNotNil(color, "Color should not be nil")
		
		// Other colors
		color = TRIKConstant.Color.black
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.clear
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.red
		XCTAssertNotNil(color, "Color should not be nil")
		color = TRIKConstant.Color.white
		XCTAssertNotNil(color, "Color should not be nil")
    }
	
	func testLanguageCodeToNameConversion() {
		// Non-existent code
		var name = TRIKConstant.Language.name(forCode: "Not an existing language code")
		XCTAssertEqual(name, TRIKConstant.Language.Name.english, "Language name does not match expected name")
		
		// Existing codes
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.arabic)
		XCTAssertEqual(name, TRIKConstant.Language.Name.arabic, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.bengali)
		XCTAssertEqual(name, TRIKConstant.Language.Name.bengali, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.chinese)
		XCTAssertEqual(name, TRIKConstant.Language.Name.chinese, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.english)
		XCTAssertEqual(name, TRIKConstant.Language.Name.english, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.french)
		XCTAssertEqual(name, TRIKConstant.Language.Name.french, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.german)
		XCTAssertEqual(name, TRIKConstant.Language.Name.german, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.hindi)
		XCTAssertEqual(name, TRIKConstant.Language.Name.hindi, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.italian)
		XCTAssertEqual(name, TRIKConstant.Language.Name.italian, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.japanese)
		XCTAssertEqual(name, TRIKConstant.Language.Name.japanese, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.portuguese)
		XCTAssertEqual(name, TRIKConstant.Language.Name.portuguese, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.punjabi)
		XCTAssertEqual(name, TRIKConstant.Language.Name.punjabi, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.russian)
		XCTAssertEqual(name, TRIKConstant.Language.Name.russian, "Language name does not match expected name")
		name = TRIKConstant.Language.name(forCode: TRIKConstant.Language.Code.spanish)
		XCTAssertEqual(name, TRIKConstant.Language.Name.spanish, "Language name does not match expected name")
	}
	
	func testLanguageNameToCodeConversion() {
		// Non-existent name
		var code = TRIKConstant.Language.code(forName: "Not an existing language name")
		XCTAssertEqual(code, TRIKConstant.Language.Code.english, "Language code does not match expected code")
		
		// Existing names
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.arabic)
		XCTAssertEqual(code, TRIKConstant.Language.Code.arabic, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.bengali)
		XCTAssertEqual(code, TRIKConstant.Language.Code.bengali, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.chinese)
		XCTAssertEqual(code, TRIKConstant.Language.Code.chinese, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.english)
		XCTAssertEqual(code, TRIKConstant.Language.Code.english, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.french)
		XCTAssertEqual(code, TRIKConstant.Language.Code.french, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.german)
		XCTAssertEqual(code, TRIKConstant.Language.Code.german, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.hindi)
		XCTAssertEqual(code, TRIKConstant.Language.Code.hindi, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.italian)
		XCTAssertEqual(code, TRIKConstant.Language.Code.italian, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.japanese)
		XCTAssertEqual(code, TRIKConstant.Language.Code.japanese, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.portuguese)
		XCTAssertEqual(code, TRIKConstant.Language.Code.portuguese, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.punjabi)
		XCTAssertEqual(code, TRIKConstant.Language.Code.punjabi, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.russian)
		XCTAssertEqual(code, TRIKConstant.Language.Code.russian, "Language code does not match expected code")
		code = TRIKConstant.Language.code(forName: TRIKConstant.Language.Name.spanish)
		XCTAssertEqual(code, TRIKConstant.Language.Code.spanish, "Language code does not match expected code")
	}

	// MARK: Support methods


}
