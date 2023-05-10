//
//  BigTouchZoneSliderTests.swift
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

class BigTouchZoneSliderTests: XCTestCase {
	// MARK: Type properties
	private static let controllerID = "SliderController"
	private static let sliderTag = 101

	// MARK: Instance properties
	var controller: UIViewController!
	var sliderCode: TRIKBigTouchZoneSlider!
	var sliderIB: TRIKBigTouchZoneSlider!

	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()

		// Get test storyboard and view controller for slider
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: BigTouchZoneSliderTests.self))
		self.controller = storyboard.instantiateViewController(withIdentifier: BigTouchZoneSliderTests.controllerID)
		if let controllerSlider = self.controller.view.viewWithTag(BigTouchZoneSliderTests.sliderTag) as? TRIKBigTouchZoneSlider {
			self.sliderIB = controllerSlider
		}
		// Preload controller's view
		_ = self.controller.view
	}

	override func tearDown() {
		self.sliderCode = nil
		self.sliderIB = nil
		self.controller = nil

		super.tearDown()
	}

	// MARK: Test methods
	func testInitCoder() {
		// Assert slider exists
		XCTAssertNotNil(self.sliderIB, "Slider should not be nil")
		
		// Assert slider is set up with default values
		XCTAssertEqual(self.sliderIB.style, TRIKBigTouchZoneSlider.Style.blue, "Slider style does not match expected style")
		XCTAssertEqual(self.sliderIB.minimumValue, TRIKBigTouchZoneSlider.defaultMinValue, "Slider minimum value does not match expected value")
		XCTAssertEqual(self.sliderIB.maximumValue, TRIKBigTouchZoneSlider.defaultMaxValue, "Slider maximum value does not match expected value")
		XCTAssertEqual(self.sliderIB.value, TRIKBigTouchZoneSlider.defaultInitialValue, "Slider value does not match expected value")
		XCTAssertEqual(self.sliderIB.interval, TRIKBigTouchZoneSlider.defaultInterval, "Slider interval does not match expected value")
	}
	
	func testInitDefault() {
		self.sliderCode = TRIKBigTouchZoneSlider(superview: self.controller.view,
												 alignmentView: self.sliderIB)
		
		// Assert initialization customized overlay as expected
		XCTAssertNotNil(self.sliderCode.superview, "The slider should have a superview after initialization")
		XCTAssertEqual(self.sliderCode.superview!, self.controller.view, "Slider superview does not match expected view")
		XCTAssertEqual(self.sliderCode.style, TRIKBigTouchZoneSlider.Style.blue, "Slider style does not match expected style")
		XCTAssertEqual(self.sliderCode.minimumValue, TRIKBigTouchZoneSlider.defaultMinValue, "Slider minimum value does not match expected value")
		XCTAssertEqual(self.sliderCode.maximumValue, TRIKBigTouchZoneSlider.defaultMaxValue, "Slider maximum value does not match expected value")
		XCTAssertEqual(self.sliderCode.value, TRIKBigTouchZoneSlider.defaultInitialValue, "Slider value does not match expected value")
		XCTAssertEqual(self.sliderCode.interval, TRIKBigTouchZoneSlider.defaultInterval, "Slider interval does not match expected value")
		XCTAssertNil(self.sliderCode.delegate, "Slider should not have a delegate")
	}
	
	func testInitWithOptions() {
		// All styles
		self.createSlider(withStyle: .blue)
		self.createSlider(withStyle: .black)
		self.createSlider(withStyle: .grey)
	}
	
	func testValueValidity() {
		// Min value greater than max value
		var min: Float = 5.0
		var max: Float = 3.0
		var initial: Float = 1.0
		var interval: Float = 1.0
		self.createSlider(minValue: min,
						  maxValue: max,
						  initialValue: initial,
						  interval: interval,
						  assertOptions: false)
		// Min and max value should have been swapped
		XCTAssertEqual(self.sliderCode.minimumValue, max, "Slider minimum value did not get adjusted as expected")
		XCTAssertEqual(self.sliderCode.maximumValue, min, "Slider maximum value did not get adjusted as expected")
		
		// Initial value greater than max value
		min = 0.0
		max = 5.0
		initial = 7.0
		interval = 1.0
		self.createSlider(minValue: min,
						  maxValue: max,
						  initialValue: initial,
						  interval: interval,
						  assertOptions: false)
		// Initial value should have been set to max value
		XCTAssertEqual(self.sliderCode.value, sliderCode.maximumValue, "Slider initial value did not get adjusted as expected")
		
		// Initial value smaller than min value
		min = 0.0
		max = 5.0
		initial = -2.0
		interval = 1.0
		self.createSlider(minValue: min,
						  maxValue: max,
						  initialValue: initial,
						  interval: interval,
						  assertOptions: false)
		// Initial value should have been set to min value
		XCTAssertEqual(self.sliderCode.value, sliderCode.minimumValue, "Slider initial value did not get adjusted as expected")
		
		// Interval negative
		min = 0.0
		max = 5.0
		initial = 2.0
		interval = -1.0
		self.createSlider(minValue: min,
						  maxValue: max,
						  initialValue: initial,
						  interval: interval,
						  assertOptions: false)
		// Interval should have been made positive
		XCTAssertEqual(self.sliderCode.interval, -interval, "Slider interval did not get adjusted as expected")
		
		// Interval greater than delta between min and max value
		min = 0.0
		max = 5.0
		initial = 2.0
		interval = 7.0
		self.createSlider(minValue: min,
						  maxValue: max,
						  initialValue: initial,
						  interval: interval,
						  assertOptions: false)
		// Interval should have been set to delta between min and max value
		XCTAssertEqual(self.sliderCode.interval, sliderCode.maximumValue - sliderCode.minimumValue, "Slider interval did not get adjusted as expected")
	}

	// MARK: Support methods
	func createSlider(withStyle style: TRIKBigTouchZoneSlider.Style = .blue,
					  minValue: Float = TRIKBigTouchZoneSlider.defaultMinValue,
					  maxValue: Float = TRIKBigTouchZoneSlider.defaultMaxValue,
					  initialValue: Float = TRIKBigTouchZoneSlider.defaultInitialValue,
					  interval: Float = TRIKBigTouchZoneSlider.defaultInterval,
					  assertOptions: Bool = true) {
		if self.sliderCode != nil {
			if self.sliderCode.superview != nil {
				self.sliderCode.removeFromSuperview()
			}
			self.sliderCode = nil
		}
		
		self.sliderCode = TRIKBigTouchZoneSlider(superview: self.controller.view,
												 alignmentView: self.sliderIB,
												 style: style,
												 minValue: minValue,
												 maxValue: maxValue,
												 initialValue: initialValue,
												 interval: interval,
												 delegate: self)
		
		if assertOptions {
			// Assert initialization options have been set correctly
			XCTAssertEqual(self.sliderCode.style, style, "Slider style does not match expected style")
			XCTAssertEqual(self.sliderCode.minimumValue, minValue, "Slider minimum value does not match expected value")
			XCTAssertEqual(self.sliderCode.maximumValue, maxValue, "Slider maximum value does not match expected value")
			XCTAssertEqual(self.sliderCode.value, initialValue, "Slider value does not match expected value")
			XCTAssertEqual(self.sliderCode.interval, interval, "Slider interval does not match expected value")
			XCTAssertNotNil(self.sliderCode.delegate, "Slider should have a delegate")
		}
	}

}

extension BigTouchZoneSliderTests: TRIKBigTouchZoneSliderDelegate {
	func slider(_ slider: TRIKBigTouchZoneSlider, didChangeValueTo value: Float) {
	}
}
