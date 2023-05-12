//
//  TRIKAutoDestroyOverlay.swift
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

// MARK: -
// MARK: Implementation
/**
View for displaying an overlay with information that will destroy itself after a specific amount of time.

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKAutoDestroyOverlay: TRIKOverlay {
	// MARK: Nested types
	

	// MARK: Type properties
	/// Default delay in seconds until the overlay's auto desctruction
	public static let defaultDestructionDelay = 1.5

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Stores the time in seconds after which the overlay destroys itself
	private let secondsUntilDestruction: Double
	
	/// Flag about whether or not the overlay can be destroyed be tapping it
	private let tapDestructionActive: Bool
	
	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKAutoDestroyOverlay.self)), but will always return nil.
			Use init(superview:
						text:
						font:
						style:
						position:
						seconds:
						tappable:)
			instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the auto destroy overlay.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- superview: The overlay's designated superview
		- text: The text to display within the overlay
		- font: The font to use within the overlay
		- style: The style of the overlay
		- position: The position of the overlay in its superview
		— seconds: Time in seconds after which the overlay destroys itself
		- tappable: Flag about whether or not the overlay can be destroyed by tapping it
	
	- returns: A fully set up instance of TRIKAutoDestroyOverlay
	*/
	public init(superview: UIView,
	            text: String,
	            font: UIFont = TRIKOverlay.defaultFont,
	            style: TRIKOverlay.Style = .white,
	            position: TRIKOverlay.Position = .bottom,
	            destroyAfter seconds: Double = TRIKAutoDestroyOverlay.defaultDestructionDelay,
	            tapToDestroy tappable: Bool = false) {
		
		self.secondsUntilDestruction = seconds
		self.tapDestructionActive = tappable
		
		super.init(superview: superview,
		           text: text,
		           font: font,
		           style: style,
		           position: position)
		
		self.setupOverlay()
	}

	// MARK: -
	// MARK: Instance methods
	/**
	Handles taps on the overlay.
	
	- parameters:
		- recognizer: The gesture recognizer triggering the method call
	*/
	@objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
		devLog("Destruction method called")
		self.dismiss(animated: true) { (_) in
			devLog("Completion handler executed.")
			self.destroy()
		}
	}
}

// MARK: -
// MARK: Setup and customization
extension TRIKAutoDestroyOverlay {
	/**
	Sets up the overlay.
	*/
	private func setupOverlay() {
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the layout of the overlay's subviews.
	*/
	private func setupSubviewLayout() {
		// Guard existence of 1st and 2nd items of constraints
		guard let ctFirstItem = self.labelConstraintAlignmentTop.firstItem as? UIView,
			  let ctSecondItem = self.labelConstraintAlignmentTop.secondItem as? UIView,
			  let cbFirstItem = self.labelConstraintAlignmentBottom.firstItem as? UIView,
			  let cbSecondItem = self.labelConstraintAlignmentBottom.secondItem as? UIView else {
			
			return
		}
		
		let ctConstant = self.labelConstraintAlignmentTop.constant
		let cbConstant = self.labelConstraintAlignmentBottom.constant
		
		// Adjust label
		self.labelConstraintAlignmentTop.isActive = false
		self.labelConstraintAlignmentTop = ctFirstItem.topAnchor.constraint(equalTo: ctSecondItem.topAnchor,
																			constant: ctConstant)
		self.labelConstraintAlignmentTop.isActive = true
		
		self.labelConstraintAlignmentBottom.isActive = false
		self.labelConstraintAlignmentBottom = cbFirstItem.bottomAnchor.constraint(equalTo: cbSecondItem.bottomAnchor,
																				  constant: cbConstant)
		self.labelConstraintAlignmentBottom.isActive = true
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		// Auto destruction
		let destroy = #selector(TRIKAutoDestroyOverlay.handleTap(_:))
		if self.tapDestructionActive {
			let tapGesture = UITapGestureRecognizer(target: self, action: destroy)
			self.isUserInteractionEnabled = true
			self.addGestureRecognizer(tapGesture)
		}
		
		self.perform(destroy, with: nil, afterDelay: self.secondsUntilDestruction)
	}
}
