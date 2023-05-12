//
//  AutoDestroyOverlayTests.swift
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
Unit test class for ``TRIKAutoDestroyOverlay``.
*/
class AutoDestroyOverlayTests: OverlayTestBase {
	// Instance properties
	var alignmentView: UIView?
}

// MARK: -
// MARK: Setup and tear-down
extension AutoDestroyOverlayTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  text: AutoDestroyOverlayTests.testString)
	}
	
	override func tearDownWithError() throws {
		self.alignmentView = nil
		
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Supporting methods
extension AutoDestroyOverlayTests {
	func createOverlay(tappable: Bool, assertOptions assert: Bool) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  text: AutoDestroyOverlayTests.testString,
											  tapToDestroy: tappable)
		guard let adOverlay = self.overlay else {
			return
		}
		adOverlay.present(animated: true) { (_) in
			if assert {
				// Assert initialization options have been set correctly
				if tappable {
					XCTAssertNotNil(adOverlay.gestureRecognizers, "Overlay should have at least one gesture recognizer assigned")
				}
				else {
					XCTAssertNil(adOverlay.gestureRecognizers, "Overlay should not have any gesture recognizers assigned")
				}
			}
		}
	}
	
	func createOverlay(withDestructionDelay delay: Double) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  text: AutoDestroyOverlayTests.testString,
											  destroyAfter: delay)
		self.overlay.present(animated: true)
	}
	
	func createOverlay(withAlignmentView useAlignmentView: Bool,
					   position: TRIKOverlay.Position) {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
		}
		
		if useAlignmentView {
			let view = UIView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			self.controller.view.addSubview(view)
			
			view.widthAnchor.constraint(equalToConstant: 100).isActive = true
			view.heightAnchor.constraint(equalToConstant: 50).isActive = true
			view.centerXAnchor.constraint(equalTo: self.controller.view.centerXAnchor).isActive = true
			view.centerYAnchor.constraint(equalTo: self.controller.view.centerYAnchor).isActive = true
			
			self.alignmentView = view
		}
		
		let extraLongTestString = OverlayTestBase.testStringLong + OverlayTestBase.testStringLong
		self.overlay = TRIKAutoDestroyOverlay(superview: self.controller.view,
											  alignmentView: alignmentView,
											  text: extraLongTestString,
											  position: position)
		
		self.overlay.present(animated: true)
		
		self.controller.view.layoutIfNeeded()
	}
}

// MARK: -
// MARK: Tests
extension AutoDestroyOverlayTests {
	func testInitCoder() {
		self.overlay = TRIKAutoDestroyOverlay(coder: NSCoder())
		
		// Assert initialization failed
		XCTAssertNil(self.overlay, "It should not be possible to initialize an auto destroy overlay with a decoder")
	}
	
	func testInitDefault() {
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(self.overlay.superview, "The overlay should have a superview after initialization")
		XCTAssertEqual(self.overlay.superview!, self.controller.view, "Overlay superview does not match expected view")
		XCTAssertNotNil(self.overlay.label.text, "The overlay's label should have a text after initialization")
		XCTAssertEqual(self.overlay.label.text!, AutoDestroyOverlayTests.testString, "Text of overlay's label does not match expected text")
		XCTAssertEqual(self.overlay.font, TRIKOverlay.defaultFont, "Overlay font does not match expected font")
		XCTAssertEqual(self.overlay.style, TRIKOverlay.Style.white, "Overlay style does not match expected style")
		XCTAssertEqual(self.overlay.position, TRIKOverlay.Position.bottom, "Overlay position does not match expected position")
	}
	
	func testInitWithOptions() {
		// Tap destruction active
		self.createOverlay(tappable: true, assertOptions: true)
		
		// Tap destruction inactive
		self.createOverlay(tappable: false, assertOptions: true)
	}
	
	func testAutoDestroy() {
		var delay = 0.75
		let timeoutDelta = 2.0
		var promise = expectation(description: "Overlay destroyed after \(delay) secs")
		
		self.createOverlay(withDestructionDelay: delay)
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			promise.fulfill()
		}
		waitForExpectations(timeout: delay + timeoutDelta) { [unowned self] (_) in
			// Assert overlay destruction
			XCTAssertNil(self.overlay.superview, "Overlay should not have a superview anymore")
		}
		
		delay = 2.0
		promise = expectation(description: "Overlay destroyed after \(delay) secs")
		
		self.createOverlay(withDestructionDelay: delay)
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
			promise.fulfill()
		}
		waitForExpectations(timeout: delay + timeoutDelta) { [unowned self] (_) in
			// Assert overlay destruction
			XCTAssertNil(self.overlay.superview, "Overlay should not have a superview anymore")
		}
	}
	
	func test_layout_noAlignmentView_positionTop() {
		self.createOverlay(withAlignmentView: false, position: .top)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let alignmentView = self.overlay.superview else {
			
			return XCTFail("Unexpected overlay type or missing superview")
		}
		
		self.assertValue(overlay.frame.midX, matches: alignmentView.frame.midX, acceptableDeviation: 0.5)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minX, alignmentView.bounds.minX + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxX, alignmentView.bounds.maxX - TRIKOverlay.padding)
		
		self.assertValue(overlay.frame.minY, matches: alignmentView.bounds.minY + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxY, alignmentView.bounds.maxY - TRIKOverlay.padding)
	}
	
	func test_layout_noAlignmentView_positionCenter() {
		self.createOverlay(withAlignmentView: false, position: .center)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let alignmentView = self.overlay.superview else {
			
			return XCTFail("Unexpected overlay type or missing superview")
		}
		
		self.assertValue(overlay.frame.midX, matches: alignmentView.frame.midX, acceptableDeviation: 0.5)
		self.assertValue(overlay.frame.midY, matches: alignmentView.frame.midY, acceptableDeviation: 0.5)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minX, alignmentView.bounds.minX + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxX, alignmentView.bounds.maxX - TRIKOverlay.padding)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minY, alignmentView.bounds.minY + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxY, alignmentView.bounds.maxY - TRIKOverlay.padding)
	}
	
	func test_layout_noAlignmentView_positionBottom() {
		self.createOverlay(withAlignmentView: false, position: .bottom)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let alignmentView = self.overlay.superview else {
			
			return XCTFail("Unexpected overlay type or missing superview")
		}
		
		self.assertValue(overlay.frame.midX, matches: alignmentView.frame.midX, acceptableDeviation: 0.5)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minX, alignmentView.bounds.minX + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxX, alignmentView.bounds.maxX - TRIKOverlay.padding)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minY, alignmentView.bounds.minY + TRIKOverlay.padding)
		self.assertValue(overlay.frame.maxY, matches: alignmentView.bounds.maxY - TRIKOverlay.padding)
	}
	
	func test_layout_noAlignmentView_positionFull() {
		self.createOverlay(withAlignmentView: false, position: .full)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let alignmentView = self.overlay.superview else {
			
			return XCTFail("Unexpected overlay type or missing superview")
		}
		
		self.assertValue(overlay.frame.midX, matches: alignmentView.frame.midX, acceptableDeviation: 0.5)
		self.assertValue(overlay.frame.midY, matches: alignmentView.frame.midY, acceptableDeviation: 0.5)
		
		XCTAssertEqual(overlay.frame.minX, alignmentView.bounds.minX + TRIKOverlay.padding)
		XCTAssertEqual(overlay.frame.maxX, alignmentView.bounds.maxX - TRIKOverlay.padding)
		
		XCTAssertEqual(overlay.frame.minY, alignmentView.bounds.minY + TRIKOverlay.padding)
		XCTAssertEqual(overlay.frame.maxY, alignmentView.bounds.maxY - TRIKOverlay.padding)
	}
	
	func test_layout_withAlignmentView_positionTop() {
		self.createOverlay(withAlignmentView: true, position: .top)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let superview = self.controller.view,
			  let alignmentView = self.alignmentView else {
			
			return XCTFail("Unexpected overlay type or missing superview or alignment view")
		}
		
		self.assertValue(overlay.frame.midX, matches: superview.bounds.midX, acceptableDeviation: 0.5)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minX, superview.bounds.minX + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxX, superview.bounds.maxX - TRIKOverlay.padding)
		
		self.assertValue(overlay.frame.maxY, matches: alignmentView.frame.minY - TRIKOverlay.padding)
		XCTAssertGreaterThanOrEqual(overlay.frame.minY, superview.bounds.minY + TRIKOverlay.padding)
	}
	
	func test_layout_withAlignmentView_positionCenter() {
		self.createOverlay(withAlignmentView: true, position: .center)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let superview = self.controller.view,
			  let alignmentView = self.alignmentView else {
			
			return XCTFail("Unexpected overlay type or missing superview or alignment view")
		}
		
		self.assertValue(overlay.frame.midX, matches: superview.bounds.midX, acceptableDeviation: 0.5)
		self.assertValue(overlay.frame.midY, matches: alignmentView.frame.midY, acceptableDeviation: 0.5)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minX, superview.bounds.minX + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxX, superview.bounds.maxX - TRIKOverlay.padding)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minY, superview.bounds.minY + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxY, superview.bounds.maxY - TRIKOverlay.padding)
	}
	
	func test_layout_withAlignmentView_positionBottom() {
		self.createOverlay(withAlignmentView: true, position: .bottom)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let superview = self.controller.view,
			  let alignmentView = self.alignmentView else {
			
			return XCTFail("Unexpected overlay type or missing superview or alignment view")
		}
		
		self.assertValue(overlay.frame.midX, matches: superview.bounds.midX, acceptableDeviation: 0.5)
		
		XCTAssertGreaterThanOrEqual(overlay.frame.minX, superview.bounds.minX + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxX, superview.bounds.maxX - TRIKOverlay.padding)
		
		self.assertValue(overlay.frame.minY, matches: alignmentView.frame.maxY + TRIKOverlay.padding)
		XCTAssertLessThanOrEqual(overlay.frame.maxY, superview.bounds.maxY - TRIKOverlay.padding)
	}
	
	func test_layout_withAlignmentView_positionFull() {
		self.createOverlay(withAlignmentView: true, position: .full)
		
		guard let overlay = self.overlay as? TRIKAutoDestroyOverlay,
			  let superview = self.controller.view,
			  let _ = self.alignmentView else {
			
			return XCTFail("Unexpected overlay type or missing superview or alignment view")
		}
		
		self.assertValue(overlay.frame.midX, matches: superview.frame.midX, acceptableDeviation: 0.5)
		self.assertValue(overlay.frame.midY, matches: superview.frame.midY, acceptableDeviation: 0.5)
		
		XCTAssertEqual(overlay.frame.minX, superview.bounds.minX + TRIKOverlay.padding)
		XCTAssertEqual(overlay.frame.maxX, superview.bounds.maxX - TRIKOverlay.padding)
		
		XCTAssertEqual(overlay.frame.minY, superview.bounds.minY + TRIKOverlay.padding)
		XCTAssertEqual(overlay.frame.maxY, superview.bounds.maxY - TRIKOverlay.padding)
	}
}
