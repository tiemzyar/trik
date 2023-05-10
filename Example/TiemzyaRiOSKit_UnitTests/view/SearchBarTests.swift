//
//  SearchBarTests.swift
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

class SearchBarTests: XCTestCase {
	// MARK: Type properties
	
	
	// MARK: Instance properties
	var searchBar: TRIKSearchBar!

	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		self.searchBar = TRIKSearchBar()
	}

	override func tearDown() {
		self.searchBar = nil

		super.tearDown()
	}

	// MARK: Test methods
    func testInitCoder() {
		self.searchBar = TRIKSearchBar(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.searchBar, "It should not be possible to initialize a search bar with a decoder")
    }
	
	func testInitDefault() {
		// Assert initialization customized search bar as expected
		XCTAssertEqual(self.searchBar.frame, CGRect.zero, "Search bar frame does not match expected frame")
		XCTAssertNil(self.searchBar.delegate, "Search bar should not have a delegate")
		XCTAssertEqual(self.searchBar.searchFieldHeight, TRIKSearchBar.defaultHeight, "Search bar height does not match expected height")
		XCTAssertEqual(self.searchBar.searchFieldPadding, TRIKSearchBar.defaultPadding, "Search bar padding does not match expected padding")
		XCTAssertFalse(self.searchBar.roundCorners, "Search bar flag for rounded corners does not match expected value")
	}
	
	func testInitWithOptions() {
		self.searchBar = TRIKSearchBar(delegate: self,
									   roundCorners: true)
		
		// Assert initialization customized search bar as expected
		XCTAssertNotNil(self.searchBar.delegate, "Search bar delegate should not be nil")
		XCTAssertTrue(self.searchBar.roundCorners, "Search bar flag for rounded corners does not match expected value")
	}
	
	func testHeightRanges() {
		self.searchBar = TRIKSearchBar(searchFieldHeight: 30.0)
		self.searchBar = TRIKSearchBar(searchFieldHeight: 35.0)
		self.searchBar = TRIKSearchBar(searchFieldHeight: 40.0)
		self.searchBar = TRIKSearchBar(searchFieldHeight: 41.0)
		self.searchBar = TRIKSearchBar(searchFieldHeight: 45.0)
		self.searchBar = TRIKSearchBar(searchFieldHeight: 46.0)
		
		XCTAssertTrue(true, "Everything should have worked fine here")
	}
	
	func testButtonVisibilityFlags() {
		// Clear button
		self.searchBar.showsClearButton = true
		self.searchBar.showsClearButton = false
		
		// Cancel button
		self.searchBar.showsCancelButton = true
		self.searchBar.showsCancelButton = false
		
		XCTAssertTrue(true, "Everything should have worked fine here")
	}

	// MARK: Support methods
	
}

extension SearchBarTests: TRIKSearchBarDelegate {
	func searchBarTextDidBeginEditing(_ searchBar: TRIKSearchBar) {
	}
	
	func searchBarTextDidEndEditing(_ searchBar: TRIKSearchBar) {
	}
	
	func searchBar(_ searchBar: TRIKSearchBar, textDidChange searchText: String) {
	}
	
	func searchBarCancelButtonClicked(_ searchBar: TRIKSearchBar) {
	}
	
	func searchBarSearchButtonClicked(_ searchBar: TRIKSearchBar) {
	}
}
