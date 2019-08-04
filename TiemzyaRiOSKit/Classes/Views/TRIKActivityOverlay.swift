//
//  TRIKActivityOverlay.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 28.09.18.
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
View for displaying an overlay during network downloads or while an app is loading content.

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKActivityOverlay: TRIKOverlay {
	// MARK: Nested types
	

	// MARK: Type properties
	/// Height of the activity overlay's button
	private static let buttonHeight: CGFloat = 25.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Style of the activity overlay
	override public var style: TRIKOverlay.Style {
		didSet {
			self.adjustActivityColorIfNecessary()
			self.activityIndicator.color = self.activityColor
			self.activityProgress.progressTintColor = self.activityColor
			self.button.setTitleColor(self.activityColor, for:UIControlState.normal)
			
			switch (self.style) {
			case .white, .light:
				self.activityProgress.trackTintColor = TRIKConstant.Color.Grey.dark
				self.button.setTitleColor(TRIKConstant.Color.Grey.dark, for:UIControlState.highlighted)
			case .dark, .black:
				self.activityProgress.trackTintColor = TRIKConstant.Color.Grey.light
				self.button.setTitleColor(TRIKConstant.Color.Grey.light, for:UIControlState.highlighted)
			case .tiemzyar:
				self.activityProgress.trackTintColor = TRIKConstant.Color.white
				self.button.setTitleColor(TRIKConstant.Color.white, for:UIControlState.highlighted)
			}
		}
	}
	
	/// Stores the color to use for the activity overlay's active elements
	private var activityColor: UIColor
	
	/// The overlay's progress bar
	public private (set) var activityProgress: UIProgressView
	
	/// The overlay's activity indicator
	public private (set) var activityIndicator: UIActivityIndicatorView
	
	/// The overlay's action button
	public private (set) var button: UIButton
	
	/// Layout constraint for the height of the overlay's button
	private var buttonConstraintHeight: NSLayoutConstraint
	
	/// Layout constraint for the top spacing of the overlay's button
	private var buttonConstraintSpacingTop: NSLayoutConstraint

	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKActivityOverlay.self)), but will always return nil.
			Use init(superview:
						text:
						font:
						style:
						position:
						activityColor:)
			instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the activity overlay.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- superview: The overlay's designated superview
		- text: The text to display within the overlay
		- font: The font to use within the overlay
		- style: The style of the overlay
		- position: The position of the overlay in its superview
		— activityColor: The color to use for the overlay's active elements
	
	- returns: A fully set up instance of TRIKActivityOverlay
	*/
	public init(superview: UIView,
	            text: String,
	            font: UIFont = TRIKOverlay.defaultFont,
	            style: TRIKOverlay.Style = .white,
	            position: TRIKOverlay.Position = .center,
	            activityColor: UIColor = TRIKConstant.Color.Blue.tiemzyar) {
		self.activityColor = activityColor
		
		self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
		self.activityProgress = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
		self.button = UIButton(frame: CGRect.zero)
		self.buttonConstraintHeight = NSLayoutConstraint()
		self.buttonConstraintSpacingTop = NSLayoutConstraint()
		
		super.init(superview: superview,
		           text: text,
		           font: font,
		           style: style,
		           position: position)
		
		self.setupOverlay()
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
	Presents the overlay with an activity indicator by setting the hidden state of the activity overlay and its activity indicator to false.
	
	- parameters:
		- animated: Flag about whether or not to animate the presentation
		- completion: Optional completion closure
	*/
	public func presentWithActivityIndicator(animated: Bool = false,
											 completion: ((Bool) -> Void)? = nil) {
		self.present(animated: animated) { (true) in
			self.activityIndicator.isHidden = false
			self.activityIndicator.startAnimating()
			self.activityProgress.isHidden = true
			
			UIView.animate(withDuration: TRIKConstant.AnimationTime.medium) {
				self.layoutIfNeeded()
				completion?(true)
			}
		}
	}
	
	/**
	Presents the overlay with a progress bar by setting the hidden state of the overlay and its progress bar to false.
	
	- parameters:
		- animated: Flag about whether or not to animate the presentation
		- completion: Optional completion closure
	*/
	public func presentWithProgressBar(animated: Bool = false,
									   completion: ((Bool) -> Void)? = nil) {
		self.present(animated: animated) { [unowned self] (true) in
			self.activityProgress.isHidden = false
			self.resetProgress()
			self.activityIndicator.isHidden = true
			
			UIView.animate(withDuration: TRIKConstant.AnimationTime.medium) {
				self.layoutIfNeeded()
				completion?(true)
			}
		}
	}
	
	/**
	Presents the overlay's activity indicator by setting its hidden state to false.
	
	- returns: The presented activity indicator
	*/
	@discardableResult public func presentActivityIndicator() -> UIActivityIndicatorView {
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
		self.activityProgress.isHidden = true
		self.resetProgress()
		
		return self.activityIndicator
	}
	
	/**
	Presents the overlay's progress bar by setting its hidden state to false.
	*/
	public func presentProgressBar() {
		self.activityProgress.isHidden = false
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
	}
	
	/**
	Updates the overlay's progress bar after a validity check of the parameter progress.
	
	- parameters:
		- progress: The new progress to set to the progress bar
	*/
	public func updateProgress(_ progress: Float) {
		switch progress {
		case let p where p < 0.0:
			self.resetProgress()
		case let p where p > 1.0:
			self.activityProgress.setProgress(1.0, animated: true)
		default:
			self.activityProgress.setProgress(progress, animated: true)
		}
	}
	
	/**
	Resets the overlay's progress bar to zero.
	*/
	private func resetProgress() {
		self.activityProgress.progress = 0.0
	}
	
	/**
	Sets the title of the overlay's button.
	
	- parameters:
		- title: The title to set for the button
	*/
	public func setButtonTitle(_ title: String) {
		self.button.setTitle(title, for: UIControlState.normal)
	}
	
	/**
	Adds target and selector for the overlay's button for the control event touchUpInside.
	
	- parameters:
		- target: The target to set for the button
		- selector: The selector to set for the button
	*/
	public func addButtonTarget(_ target: Any?, action: Selector) {
		self.button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
	}
	
	/**
	Removes target and selector from the overlay's button for the control event touchUpInside.
	
	- parameters:
		- target: The target to remove from the button
		- selector: The selector to remove from the button
	*/
	public func removeButtonTarget(_ target: Any?, action: Selector) {
		self.button.removeTarget(target, action: action, for: UIControlEvents.touchUpInside)
	}
	
	/**
	Presents the overlay's button by setting its hidden state to false.
	*/
	public func presentButton() {
		self.button.isHidden = false
		
		self.buttonConstraintHeight.constant = TRIKActivityOverlay.buttonHeight
		self.buttonConstraintSpacingTop.constant = TRIKOverlay.subviewSpacing
		
		UIView.animate(withDuration: TRIKConstant.AnimationTime.medium) {
			self.layoutIfNeeded()
		}
	}
	
	/**
	Dismisses the overlay's button by setting its hidden state to true.
	*/
	public func dismissButton() {
		self.button.isHidden = true
		
		self.buttonConstraintHeight.constant = 0.0
		self.buttonConstraintSpacingTop.constant = 0.0
		
		UIView.animate(withDuration: TRIKConstant.AnimationTime.medium) {
			self.layoutIfNeeded()
		}
	}
	
	/**
	Dismisses the overlay by setting its own as well as its subviews' hidden state to true.
	
	The optional completion closure will also be triggered if animated is false.
	
	- parameters:
		- animated: Flag about whether or not to animate the dismissal
		- completion: Optional completion closure
	*/
	override public func dismiss(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
		super.dismiss(animated: animated) { [unowned self] (finished) in
			devLog("Completion handler executed.")
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			self.resetProgress()
			self.activityProgress.isHidden = true
			self.button.isHidden = true
			completion?(finished)
		}
	}
}

// MARK: -
// MARK: Setup and customization
extension TRIKActivityOverlay {
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
		// Activity indicator
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.activityIndicator)
		self.addConstraint(NSLayoutConstraint(item: self.activityIndicator,
											  attribute: NSLayoutAttribute.centerX,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.centerX,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.activityIndicator,
											  attribute: NSLayoutAttribute.top,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.top,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.activityIndicator,
											  attribute: NSLayoutAttribute.bottom,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self.label,
											  attribute: NSLayoutAttribute.top,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.subviewSpacing))
		
		// Progess bar
		self.activityProgress.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.activityProgress)
		self.addConstraint(NSLayoutConstraint(item: self.activityProgress,
											  attribute: NSLayoutAttribute.centerY,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self.activityIndicator,
											  attribute: NSLayoutAttribute.centerY,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.activityProgress,
											  attribute: NSLayoutAttribute.leading,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.leading,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.activityProgress,
											  attribute: NSLayoutAttribute.trailing,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.trailing,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
		
		// Action button
		self.button.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.button)
		self.buttonConstraintHeight = NSLayoutConstraint(item: self.button,
														 attribute: NSLayoutAttribute.height,
														 relatedBy: NSLayoutRelation.equal,
														 toItem: nil,
														 attribute: NSLayoutAttribute.notAnAttribute,
														 multiplier: 1.0,
														 constant: TRIKActivityOverlay.buttonHeight)
		self.button.addConstraint(self.buttonConstraintHeight)
		self.addConstraint(NSLayoutConstraint(item: self.button,
											  attribute: NSLayoutAttribute.centerX,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.centerX,
											  multiplier: 1.0,
											  constant: 0.0))
		self.buttonConstraintSpacingTop = NSLayoutConstraint(item: self.button,
															 attribute: NSLayoutAttribute.top,
															 relatedBy: NSLayoutRelation.equal,
															 toItem: self.label,
															 attribute: NSLayoutAttribute.bottom,
															 multiplier: 1.0,
															 constant: TRIKOverlay.subviewSpacing)
		self.addConstraint(self.buttonConstraintSpacingTop)
		self.addConstraint(NSLayoutConstraint(item: self.button,
											  attribute: NSLayoutAttribute.bottom,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.bottom,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
		self.buttonConstraintHeight.constant = 0.0
		self.buttonConstraintSpacingTop.constant = 0.0
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		self.adjustActivityColorIfNecessary()
		
		// Activity indicator
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.isHidden = true
		self.activityIndicator.color = self.activityColor
		
		// Progess bar
		self.activityProgress.isHidden = true
		self.activityProgress.progressTintColor = self.activityColor
		switch (self.style) {
		case .white, .light:
			self.activityProgress.trackTintColor = TRIKConstant.Color.Grey.dark
		case .dark, .black, .tiemzyar:
			self.activityProgress.trackTintColor = TRIKConstant.Color.Grey.light
		}
		
		// Action button
		self.button.titleLabel!.font = self.font
		self.button.isHidden = true
		self.button.setTitleColor(self.activityColor, for:UIControlState.normal)
		switch (self.style) {
		case .white, .light:
			self.button.setTitleColor(TRIKConstant.Color.Grey.dark, for:UIControlState.highlighted)
		case .dark, .black, .tiemzyar:
			self.button.setTitleColor(TRIKConstant.Color.Grey.light, for:UIControlState.highlighted)
		}
	}
	
	/**
	Changes the overlay's style.
	
	- parameters:
		- style: The new style to set
	*/
	public func setStyle(_ style: TRIKOverlay.Style) {
		self.style = style
	}
	
	/**
	Adjusts the overlay's activity color if necessary (for visibility reasons).
	*/
	private func adjustActivityColorIfNecessary() {
		var adjustColor = false
		
		switch self.style {
		case .white:
			if activityColor == TRIKConstant.Color.white || activityColor == TRIKConstant.Color.Grey.dark {
				adjustColor = true
			}
		case .light, .dark:
			if activityColor == TRIKConstant.Color.Grey.light || activityColor == TRIKConstant.Color.Grey.dark {
				adjustColor = true
			}
		case .black:
			if activityColor == TRIKConstant.Color.Grey.light || activityColor == TRIKConstant.Color.black {
				adjustColor = true
			}
		case .tiemzyar:
			if activityColor == TRIKConstant.Color.Blue.tiemzyar {
				self.activityColor = TRIKConstant.Color.white
			}
		}
		
		if adjustColor {
			self.activityColor = TRIKConstant.Color.Blue.tiemzyar
		}
	}
}
