//
//  TRIKInsetLabel.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 11.10.18.
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
Label with custom insets.

Source
-
https://stackoverflow.com/a/21267507
*/
@IBDesignable
public class TRIKInsetLabel: UILabel {
	// MARK: Nested types


	// MARK: Type properties
	/// Edge insets with zero points on all sides
	public static let zeroInsets: UIEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
	

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Stores the edge insets to apply to the inset label's text
	public var textInsets: UIEdgeInsets! {
		didSet {
			self.invalidateIntrinsicContentSize()
		}
	}
	
	/// Calculates the inset label's intrinsic content size subject to its edge insets
	override public var intrinsicContentSize: CGSize {
		var size = super.intrinsicContentSize
		size.width += self.textInsets.left + self.textInsets.right
		size.height += self.textInsets.top + self.textInsets.bottom
		
		return size
	}

	// MARK: -
	// MARK: View lifecycle
	/**
	The designated initializer of the inset label for initialization from code.
	
	- parameters:
		- frame: The frame for the inset label
		- insets: The edge insets to apply to the inset label
	
	- returns: A fully set up instance of TRIKInsetLabel
	*/
	public init(frame: CGRect, textInsets insets: UIEdgeInsets = TRIKInsetLabel.zeroInsets) {
		self.textInsets = insets
		
		super.init(frame: frame)
	}
	
	/**
	The designated initializer of the inset label for initialization from a storyboard.
	
	Discussion
	-
	Sets the label's text insets to zero.
	
	- parameters:
		- aDecoder: Coder for unarchiving the inset label
	
	- returns: A fully set up instance of TRIKInsetLabel
	*/
	required public init?(coder aDecoder: NSCoder) {
		self.textInsets = TRIKInsetLabel.zeroInsets
		super.init(coder: aDecoder)
	}
	
	/**
	Adds edge insets to the inset label's rectangle for drawing text.
	
	- parameters:
		- rect: The rectangle in which to draw the inset label's text
	*/
	override public func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: self.textInsets))
	}

	// MARK: -
	// MARK: Instance methods
	override public func textRect(forBounds bounds: CGRect,
								  limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		let insetRect = bounds.inset(by: self.textInsets)
		let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: self.numberOfLines)
		let invertedInsets = UIEdgeInsets(top: -self.textInsets.top,
										  left: -self.textInsets.left,
										  bottom: -self.textInsets.bottom,
										  right: -self.textInsets.right)
		
		return textRect.inset(by: invertedInsets)
	}
}


// MARK: -
// MARK: Interface Builder insets access
public extension TRIKInsetLabel {
	/// Provides convenience access to the bottom property of the inset label's text insets for Interface Builder
	@IBInspectable
	var bottomTextInset: CGFloat {
		get {
			return self.textInsets.bottom
		}
		set {
			self.textInsets.bottom = newValue
		}
	}
	
	/// Provides convenience access to the left property of the inset label's text insets for Interface Builder
	@IBInspectable
	var leftTextInset: CGFloat {
		get {
			return self.textInsets.left
		}
		set {
			self.textInsets.left = newValue
		}
	}
	
	/// Provides convenience access to the right property of the inset label's text insets for Interface Builder
	@IBInspectable
	var rightTextInset: CGFloat {
		get {
			return self.textInsets.right
		}
		set {
			self.textInsets.right = newValue
		}
	}
	
	/// Provides convenience access to the top property of the inset label's text insets for Interface Builder
	@IBInspectable
	var topTextInset: CGFloat {
		get {
			return self.textInsets.top
		}
		set {
			self.textInsets.top = newValue
		}
	}
}
