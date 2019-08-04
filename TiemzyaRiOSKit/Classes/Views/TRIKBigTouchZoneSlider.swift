//
//  TRIKBigTouchZoneSlider.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 04.12.18.
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

// MARK: Imports
import UIKit

// MARK: -
// MARK: Implementation
/**
UISlider subclass with increased touch sensitive area for changing the slider value.

Discussion
-
Set a slider delegate to get notified about slider value changes.

Metadata:
-
Author: tiemzyar

Revision history:
- Created class
*/
public class TRIKBigTouchZoneSlider: UISlider {
	// MARK: Nested types
	/**
	Enumeration of slider styles.
	
	Cases:
	- grey
	- blue
	- black
	*/
	public enum Style: Int {
		case grey = 0
		case blue
		case black
	}

	// MARK: Type properties
	/// Default maximum value of the slider
	public static let defaultMaxValue: Float = 1.0
	
	/// Default minimum value of the slider
	public static let defaultMinValue: Float = 0.0
	
	/// Default initial value of the slider
	public static let defaultInitialValue: Float = 0.0
	
	/// Default interval of the slider
	public static let defaultInterval: Float = 1.0
	
	/// Inset for the slider's touch area (set to negative value for increased sensitivity)
	private static let touchAreaInset: CGFloat = -15.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// View to which the slider should be aligned
	private var alignmentView: UIView?
	
	/// The slider's delegate
	public var delegate: TRIKBigTouchZoneSliderDelegate?
	
	/// Stores the interval between the slider's valid values
	internal private (set) var interval: Float = TRIKBigTouchZoneSlider.defaultInterval
	
	/// The slider's style
	internal private (set) var style: TRIKBigTouchZoneSlider.Style = .blue {
		didSet {
			self.applyStyle()
		}
	}
	

	// MARK: -
	// MARK: View lifecycle
	/**
	The designated initializer for initializing a big touch zone slider from a storyboard. Initializes the slider's properties with default values.
	
	Discussion
	-
	Use the method setStyle(_:minValue:maxValue:initialValue:interval:) for setting up the big touch zone slider with the desired values after the controller's view containing the slider did load.
	
	See discussion of the initializer init(superview:alignmentView:style:minValue:maxValue:initialValue:interval:) for information about how to react to slider value changes.
	
	- parameters:
		- aDecoder: Decoder used for initializing the slider
	
	- returns: An instance of TRIKBigTouchZoneSlider set up with default values
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setStyle()
		self.customize()
	}
	
	/**
	The designated initializer for initializing a big touch zone slider from code. Sets up the slider's layout in its superview and initializes the slider's properties by triggering a method call of setStyle(_:minValue:maxValue:initialValue:interval:).
	
	- parameters:
		- superview: The slider's designated superview
		- alignmentView: The view to which the slider will be aligned horizontally and in which it will be centered vertically
		- style: The style to apply to the slider
		- minValue: The minimum value for the slider
		- maxValue: The maximum value for the slider
		- initialValue: The initial value for the slider
		- interval: The interval between values of the slider
		- delegate: The slider's delegate
	
	- returns: A fully set up instance of TRIKBigTouchZoneSlider
	*/
	public init(superview: UIView,
				alignmentView: UIView,
				style: TRIKBigTouchZoneSlider.Style = .blue,
				minValue: Float = TRIKBigTouchZoneSlider.defaultMinValue,
				maxValue: Float = TRIKBigTouchZoneSlider.defaultMaxValue,
				initialValue: Float = TRIKBigTouchZoneSlider.defaultInitialValue,
				interval: Float = TRIKBigTouchZoneSlider.defaultInterval,
				delegate: TRIKBigTouchZoneSliderDelegate? = nil) {
		self.alignmentView = alignmentView
		self.delegate = delegate
		
		super.init(frame: CGRect.zero)
		
		superview.addSubview(self)
		self.setupSlider(withStyle: style,
						 minValue: minValue,
						 maxValue: maxValue,
						 initialValue: initialValue,
						 interval: interval)
	}

	// MARK: Drawing
	/*
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
		// Drawing code
	}
	*/

	// MARK: -
	// MARK: Instance methods
	/**
	Increases the touch sensitive area for changing the slider's value.
	
	- parameters:
		- point: Point of a touch
		- event: Event triggering the method call
	
	- returns: true, if the touch is inside the increased touch sensitive area, false otherwise.
	*/
	override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		var bounds = self.bounds
		bounds = bounds.insetBy(dx: TRIKBigTouchZoneSlider.touchAreaInset, dy: TRIKBigTouchZoneSlider.touchAreaInset)

		return bounds.contains(point)
	}
	
	/**
	Makes the slider react to tap events.
	
	- parameters:
		- touch: Touch on the slider
		- event: Event triggering the method call
	
	- returns: true
	*/
//	override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//		return true
//	}
	
	/**
	Retrieves a custom thumb image from the TRIK framework's resource bundle and resizes it to fit into the slider.
	
	- returns: The resized thumb image
	*/
	private func createThumbImage(withName imageName: String) -> UIImage? {
		let image = UIImage(named: imageName,
							in: TRIKUtil.trikResourceBundle(),
							compatibleWith: nil)
		let destinationRect = CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0)
		UIGraphicsBeginImageContextWithOptions(destinationRect.size, false, 0.0)
		image?.draw(in: destinationRect)
		let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return resizedImage
	}
	
	/**
	Calculates the new slider value subject to the slider's interval and posts a notification about the value change.
	
	- parameters:
		- sender: Slider instance triggering the method call
	*/
	@objc private func sliderValueDidChange(_ sender: TRIKBigTouchZoneSlider) {
		loop:for index in stride(from: self.minimumValue, through: self.maximumValue, by: self.interval) {
			if sender.value > index && sender.value < index + self.interval {
				if sender.value - index < index + self.interval - sender.value {
					sender.setValue(index, animated: true)
				}
				else {
					sender.setValue(index + self.interval, animated: true)
				}
				break loop
			}
		}
		
		self.delegate?.slider(sender, didChangeValueTo: sender.value)
	}
}

// MARK: -
// MARK: Setup and initialization
extension TRIKBigTouchZoneSlider {
	/**
	Sets up the slider.
	*/
	private func setupSlider(withStyle style: TRIKBigTouchZoneSlider.Style,
								 minValue: Float,
								 maxValue: Float,
								 initialValue: Float,
								 interval: Float) {
		self.setupSliderLayout()
		self.customize()
		self.setStyle(style,
					  minValue: minValue,
					  maxValue: maxValue,
					  initialValue: initialValue,
					  interval: interval)
		self.applyStyle()
	}
	
	/**
	Sets up the slider's layout in its superview.
	*/
	private func setupSliderLayout() {
		self.translatesAutoresizingMaskIntoConstraints = false
		if let sview = self.superview, let aview = self.alignmentView {
			sview.addConstraint(NSLayoutConstraint(item: self,
												   attribute: NSLayoutAttribute.width,
												   relatedBy: NSLayoutRelation.equal,
												   toItem: aview,
												   attribute: NSLayoutAttribute.width,
												   multiplier: 1.0,
												   constant: 0.0))
			sview.addConstraint(NSLayoutConstraint(item: self,
												   attribute: NSLayoutAttribute.centerX,
												   relatedBy: NSLayoutRelation.equal,
												   toItem: aview,
												   attribute: NSLayoutAttribute.centerX,
												   multiplier: 1.0,
												   constant: 0.0))
			sview.addConstraint(NSLayoutConstraint(item: self,
												   attribute: NSLayoutAttribute.centerY,
												   relatedBy: NSLayoutRelation.equal,
												   toItem: aview,
												   attribute: NSLayoutAttribute.centerY,
												   multiplier: 1.0,
												   constant: 0.0))
		}
	}
	
	/**
	Customizes the slider.
	*/
	private func customize() {
		self.addTarget(self, action: #selector(TRIKBigTouchZoneSlider.sliderValueDidChange(_:)), for: .valueChanged)
	}
	
	/**
	Sets the slider's style, minimum, maximum and initial value as well as its interval after performing validity checks on the passed parameters.
	
	- parameters:
		- style: Style to apply to the slider
		- minValue: Minimum slider value
		- maxValue: Maximum slider value
		- initialValue: Initial slider value
		- interval: Interval between two valid slider values
	*/
	public func setStyle(_ style: TRIKBigTouchZoneSlider.Style = TRIKBigTouchZoneSlider.Style.blue,
						 minValue: Float = TRIKBigTouchZoneSlider.defaultMinValue,
						 maxValue: Float = TRIKBigTouchZoneSlider.defaultMaxValue,
						 initialValue: Float = TRIKBigTouchZoneSlider.defaultInitialValue,
						 interval: Float = TRIKBigTouchZoneSlider.defaultInterval) {
		self.style = style
		
		var min = minValue
		var max = maxValue
		var initial = initialValue
		var vInterval = interval
		// Check parameter values before assignment
		if minValue > maxValue {
			min = maxValue
		}
		if maxValue < minValue {
			max = minValue
		}
		if initialValue > max {
			initial = max
		}
		else if initialValue < min {
			initial = min
		}
		if interval < 0 {
			vInterval = -interval
		}
		if vInterval > max - min {
			vInterval = max - min
		}
		
		self.minimumValue = min
		self.maximumValue = max
		self.setValue(initial, animated: false)
		self.interval = vInterval
	}
	
	/**
	Applies style changes to the slider.
	*/
	private func applyStyle() {
		var thumbImage: UIImage?
		let minTrackColor: UIColor
		switch self.style {
		case .grey:
			thumbImage = self.createThumbImage(withName: "TRIKSliderThumbImageGrey.png")
			minTrackColor = TRIKConstant.Color.Grey.dark
		case .blue:
			thumbImage = self.createThumbImage(withName: "TRIKSliderThumbImageBlue.png")
			minTrackColor = TRIKConstant.Color.Blue.tiemzyar
		case .black:
			thumbImage = self.createThumbImage(withName: "TRIKSliderThumbImageBlack.png")
			minTrackColor = TRIKConstant.Color.black
		}
		
		self.setThumbImage(thumbImage, for: .normal)
		self.setThumbImage(thumbImage, for: .highlighted)
		self.minimumTrackTintColor = minTrackColor
		self.maximumTrackTintColor = TRIKConstant.Color.Grey.light
	}
}
