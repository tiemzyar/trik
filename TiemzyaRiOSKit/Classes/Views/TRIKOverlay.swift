//
//  TRIKOverlay.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 04.10.18.
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

// MARK: Imports
import UIKit
import QuartzCore

// MARK: -
// MARK: Implementation
/**
Base class for overlays.

Contains common functionality of all overlays in the TRIK framework.

Metadata:
-
Author: tiemzyar

Revision history:
- Created view as base class for overlays
*/
public class TRIKOverlay: UIView {
	// MARK: Nested types
	/**
	Enumeration of overlay styles.
	
	Cases:
	- white
	- light
	- dark
	- black
	- tiemzyar
	*/
	public enum Style: Int {
		case white = 0
		case light
		case dark
		case black
		case tiemzyar
	}
	
	/**
	Enumeration of overlay positions.
	
	Cases:
	- top (centered on x-axis, top on y-axis)
	- center (centered on x- and y-axis)
	- bottom (centered on x-axis, bottom on y-axis)
	- full (centered on x- and y-axis, stretching complete screen)
	*/
	public enum Position: Int {
		case top = 0
		case center
		case bottom
		case full
	}

	// MARK: Type properties
	/// Corner radius of the overlay
	internal static let cornerRadius: CGFloat = 5.0
	
	/// Default font of the overlay
	public static let defaultFont = UIFont.systemFont(ofSize: 10.0)
	
	/// Minimum width of the overlay's label
	private static let labelMinWidth: CGFloat = 100.0
	
	/// Spacing between the overlay and its subviews
	internal static let padding: CGFloat = 10.0
	
	/// Spacing between the overlay's subviews
	internal static let subviewSpacing: CGFloat = 10.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Stores the font to use within the overlay
	internal private (set) var font: UIFont
	
	/// The style of the overlay
	public var style: TRIKOverlay.Style {
		didSet {
			self.setBackgroundColor()
			self.setTextColor()
		}
	}
	
	/// The position of the overlay in its superview
	internal private (set) var position: TRIKOverlay.Position
	
	/// View used for background color and transparency
	private var backgroundView: UIView
	
	/// Label within the overlay
	public private (set) var label: UILabel
	
	/// Constraint for the overlay's label bottom alignment
	internal var labelConstraintAlignmentBottom: NSLayoutConstraint!
	
	/// Constraint for the overlay's label top alignment
	internal var labelConstraintAlignmentTop: NSLayoutConstraint!
	
	/// Constraint for the overlay's bottom alignment for layout position `bottom`
	internal var overlayAnchorBottom: NSLayoutConstraint!
	
	/// Constraint for the overlay's bottom alignment for layout position `top`
	internal var overlayAnchorBottomLessEqual: NSLayoutConstraint!
	
	/// Constraint for the overlay's center y alignment
	internal var overlayAnchorCenterY: NSLayoutConstraint!
	
	/// Constraint for the overlay's top alignment for layout position `top`
	internal var overlayAnchorTop: NSLayoutConstraint!
	
	/// Constraint for the overlay's top alignment for layout position `bottom`
	internal var overlayAnchorTopGreaterEqual: NSLayoutConstraint!

	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKOverlay.self)), but will always return nil.
			Use init(superview:
						text:
						font:
						style:
						position:)
			instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the overlay.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- superview: The overlay's designated superview
		- text: The text to display within the overlay
		- font: The font to use within the overlay
		- style: The style of the overlay
		- position: The position of the overlay in its superview
	
	- returns: A fully set up instance of TRIKOverlay
	*/
	public init(superview: UIView,
	            text: String,
	            font: UIFont = TRIKOverlay.defaultFont,
	            style: TRIKOverlay.Style = .white,
	            position: TRIKOverlay.Position = .center) {
		
		self.font = font
		self.style = style
		self.position = position
		
		self.backgroundView = UIView(frame: CGRect.zero)
		self.label = UILabel(frame: CGRect.zero)
		self.label.text = text
		
		super.init(frame: CGRect.zero)
		
		self.isHidden = true
		self.alpha = TRIKConstant.AlphaValue.none
		self.layer.cornerRadius = TRIKOverlay.cornerRadius
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false
		superview.addSubview(self)
		
		self.setupOverlay()
	}

	// MARK: -
	// MARK: Instance methods
	/**
	Presents the overlay by setting its hidden state to false.
	
	Discussion
	-
	The optional completion closure will always be triggered, even if animated is false.
	
	- parameters:
		- animated: Flag about whether or not to animate the presentation
		- completion: Optional completion closure
	*/
	public func present(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
		if self.isHidden {
			self.isHidden = false
			if animated {
				UIView.animate(withDuration: TRIKConstant.AnimationTime.short, animations: {
					self.alpha = TRIKConstant.AlphaValue.full
				}, completion: completion)
			}
			else {
				self.alpha = TRIKConstant.AlphaValue.full
				completion?(true)
			}
		}
	}
	
	/**
	Sets the overlay's info text.
	
	- parameters:
		- text: The text to display
	*/
	public func setText(_ text: String) {
		self.label.text = text
	}
	
	/**
	Dismisses the overlay by setting its hidden state to true.
	
	The optional completion closure will also be triggered if animated is false.
	
	- parameters:
		- animated: Flag about whether or not to animate the dismissal
		- completion: Optional completion closure
	*/
	public func dismiss(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
		if !self.isHidden {
			if animated {
				UIView.animate(withDuration: TRIKConstant.AnimationTime.short, animations: {
					self.alpha = TRIKConstant.AlphaValue.none
				}, completion: { (true) in
					self.isHidden = true
					completion?(true)
				})
			}
			else {
				self.alpha = TRIKConstant.AlphaValue.none
				self.isHidden = true
				completion?(true)
			}
		}
	}
	
	/**
	Destroys the overlay by removing it from its superview.
	*/
	public func destroy() {
		if self.superview != nil {
			self.removeFromSuperview()
		}
	}
	
}

// MARK: -
// MARK: Setup and customization
extension TRIKOverlay {
	/**
	Sets up the overlay.
	*/
	private func setupOverlay() {
		self.setupOverlayLayout()
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets the overlay's background color.
	*/
	private func setBackgroundColor() {
		switch self.style {
		case .white:
			self.backgroundView.backgroundColor = TRIKConstant.Color.white
		case .light:
			self.backgroundView.backgroundColor = TRIKConstant.Color.Grey.light
		case .dark:
			self.backgroundView.backgroundColor = TRIKConstant.Color.Grey.dark
		case .black:
			self.backgroundView.backgroundColor = TRIKConstant.Color.black
		case .tiemzyar:
			self.backgroundView.backgroundColor = TRIKConstant.Color.Blue.tiemzyar
		}
	}
	
	/**
	Sets the overlay's label text color.
	*/
	private func setTextColor() {
		switch (self.style) {
		case .white, .light:
			self.label.textColor = TRIKConstant.Color.black
		case .dark, .black:
			self.label.textColor = TRIKConstant.Color.white
		case .tiemzyar:
			self.label.textColor = TRIKConstant.Color.white
		}
	}
	
	/**
	Sets up the overlay's layout in its superview.
	*/
	private func setupOverlayLayout() {
		if let sview = self.superview {
			let centerX = self.centerXAnchor.constraint(equalTo: sview.centerXAnchor)
			self.overlayAnchorCenterY = self.centerYAnchor.constraint(equalTo: sview.centerYAnchor)
			
			self.overlayAnchorTop = self.topAnchor.constraint(equalTo: sview.topAnchor,
															  constant: TRIKOverlay.padding)
			self.overlayAnchorTopGreaterEqual = self.topAnchor.constraint(greaterThanOrEqualTo: sview.topAnchor,
																		  constant: TRIKOverlay.padding)
			
			let leadingEqual = self.leadingAnchor.constraint(equalTo: sview.leadingAnchor,
															 constant: TRIKOverlay.padding)
			let leadingGreaterEqual = self.leadingAnchor.constraint(greaterThanOrEqualTo: sview.leadingAnchor,
																	constant: TRIKOverlay.padding)
			
			self.overlayAnchorBottom = self.bottomAnchor.constraint(equalTo: sview.bottomAnchor,
																	constant: -TRIKOverlay.padding)
			self.overlayAnchorBottomLessEqual = self.bottomAnchor.constraint(lessThanOrEqualTo: sview.bottomAnchor,
																			 constant: -TRIKOverlay.padding)
			
			switch self.position {
			case .top:
				centerX.isActive = true
				self.overlayAnchorTop.isActive = true
				leadingGreaterEqual.isActive = true
				self.overlayAnchorBottomLessEqual.isActive = true
			case .center:
				centerX.isActive = true
				self.overlayAnchorCenterY.isActive = true
				self.overlayAnchorTopGreaterEqual.isActive = true
				leadingGreaterEqual.isActive = true
			case .bottom:
				centerX.isActive = true
				self.overlayAnchorTopGreaterEqual.isActive = true
				leadingGreaterEqual.isActive = true
				self.overlayAnchorBottom.isActive = true
			case .full:
				centerX.isActive = true
				self.overlayAnchorCenterY.isActive = true
				self.overlayAnchorTop.isActive = true
				leadingEqual.isActive = true
			}
		}
	}
	
	/**
	Sets up the layout of the overlay's subviews.
	*/
	private func setupSubviewLayout() {
		// Background view
		self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.backgroundView)
		self.backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		
		// Text
		self.label.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.label)
		self.label.setContentCompressionResistancePriority(.required, for: NSLayoutConstraint.Axis.vertical)
		self.label.widthAnchor.constraint(greaterThanOrEqualToConstant: TRIKOverlay.labelMinWidth).isActive = true
		self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: TRIKOverlay.padding).isActive = true
		self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -TRIKOverlay.padding)
			.isActive = true
		
		self.labelConstraintAlignmentTop = self.label.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor,
																		   constant: TRIKOverlay.padding)
		self.labelConstraintAlignmentTop.isActive = true
		self.labelConstraintAlignmentBottom = self.label.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor,
																				 constant: -TRIKOverlay.padding)
		self.labelConstraintAlignmentBottom.isActive = true
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		// Background view
		self.backgroundView.alpha = TRIKConstant.AlphaValue.a090
		self.setBackgroundColor()
		
		// Text
		self.label.font = self.font
		self.label.numberOfLines = 0
		self.setTextColor()
	}
}
