//
//  CommonTestBase.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 09.05.23.
//  Copyright © 2023 tiemzyar. All rights reserved.
//

import UIKit
import XCTest

@testable import TiemzyaRiOSKit

/**
Base class providing common functionality for other test classes.
*/
class CommonTestBase: XCTestCase {
	// MARK: Type properties
	static let expectationTimeout = 4.0
	/// Extended expectation timeout for test classes, where notifications can take quite long to come in
	static let extendedExpectationTimeout = 30.0
}

// MARK: -
// MARK: Assertion methods
extension CommonTestBase {
	@objc(assertCGFloatValue:::)
	func assertValue(_ actual: CGFloat, matches expected: CGFloat, acceptableDeviation: CGFloat = 0.01) {
		self.assertValue(Double(actual), matches: Double(expected), acceptableDeviation: Double(acceptableDeviation))
	}
	
	@objc(assertDoubleValue:::)
	func assertValue(_ actual: Double, matches expected: Double, acceptableDeviation: Double = 0.01) {
		let expectedValueRange = (expected - acceptableDeviation)...(expected + acceptableDeviation)
		XCTAssertTrue(expectedValueRange.contains(actual),
					  "Value '\(actual)' is outside of expected range '\(expectedValueRange)'")
	}
}

// MARK: -
// MARK: Async testing methods
extension CommonTestBase {
	func waitForExpectations(withTimeout timeout: TimeInterval = 30.0) {
		waitForExpectations(timeout: timeout) { (error) in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func wait(for expectations: [XCTestExpectation], seconds timeout: TimeInterval = CommonTestBase.expectationTimeout) {
		wait(for: expectations, timeout: timeout)
	}
	
	func waitWithoutBlockingMainThread(for timeInterval: TimeInterval = 0.1,
									   useDedicatedQueue: Bool = false) {
		
		let expectation = expectation(description: "Just waiting for a given time on a thread other than the main thread")
		
		var waitingQueue = DispatchQueue.global(qos: .default)
		if useDedicatedQueue {
			waitingQueue = DispatchQueue.init(label: "Waiting Queue",
											  qos: .default,
											  attributes: [.concurrent])
		}
		
		waitingQueue.async {
			Thread.sleep(forTimeInterval: timeInterval)
			expectation.fulfill()
		}
		
		let waitingTimeout = timeInterval + 1.0
		self.waitForExpectations(withTimeout: waitingTimeout)
	}
}
