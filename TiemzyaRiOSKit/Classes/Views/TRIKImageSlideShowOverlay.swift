//
//  TRIKImageSlideShowOverlay.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 20.11.18.
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
import QuartzCore

// MARK: -
// MARK: Implementation
/**
Skeletal structure of an overlay for presenting a slide show of zoomable images.

Discussion
-
For actual image slide shows, use the classes TRIKPagingImageSlideShowOverlay or TRIKStaticImageSlideShowOverlay.

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKImageSlideShowOverlay: TRIKOverlay {
	// MARK: Nested types
	/**
	Enumeration of slide show button styles.
	
	Defined types:
	- circle
	- rect
	- roundedRect
	*/
	public enum ButtonStyle: Int {
		case circle = 0
		case rect
		case roundedRect
	}
	
	/**
	Enumeration of subview visibility levels for the image slide show.
	*/
	public enum ButtonAlphaLevel: CGFloat {
		case weak = 0.25
		case medium = 0.5
		case strong = 0.75
		case full = 1.0
	}

	// MARK: Type properties
	/// Standard side length of the overlay's buttons (dismiss, previous, next)
	internal static let buttonSideLength: CGFloat = 40.0
	
	/// Image to display when a slide show image cannot be found or accessed or is broken
	internal static var dummyImage: UIImage? = {
		let languageCode = TRIKUtil.Language.currentLanguage().languageCode
		
		guard let bundle = TRIKUtil.trikResourceBundle(), let path = bundle.path(forResource: languageCode, ofType: TRIKConstant.FileManagement.FileExtension.lproj) else {
			return nil
		}
		
		let pathURL = URL(fileURLWithPath: path)
		
		return UIImage(contentsOfFile: pathURL.appendingPathComponent("TRIKImageBroken.png").path)
	}()
	
	/// Image name for a dark style dismiss button with circular frame
	private static let imageDismissDarkCircle = "TRIKButtonDismissDarkCircle.png"
	
	/// Image name for a dark style dismiss button with rectangular frame
	private static let imageDismissDarkRect = "TRIKButtonDismissDarkRect.png"
	
	/// Image name for a dark style dismiss button with rounded rectangular frame
	private static let imageDismissDarkRoundedRect = "TRIKButtonDismissDarkRoundedRect.png"
	
	/// Image name for a light style dismiss button with circular frame
	private static let imageDismissLightCircle = "TRIKButtonDismissLightCircle.png"
	
	/// Image name for a light style dismiss button with rectangular frame
	private static let imageDismissLightRect = "TRIKButtonDismissLightRect.png"
	
	/// Image name for a light style dismiss button with rounded rectangular frame
	private static let imageDismissLightRoundedRect = "TRIKButtonDismissLightRoundedRect.png"
	
	/// Image name for a dark style next button with circular frame
	private static let imageNextDarkCircle = "TRIKButtonNextDarkCircle.png"
	
	/// Image name for a dark style next button with rectangular frame
	private static let imageNextDarkRect = "TRIKButtonNextDarkRect.png"
	
	/// Image name for a dark style next button with rounded rectangular frame
	private static let imageNextDarkRoundedRect = "TRIKButtonNextDarkRoundedRect.png"
	
	/// Image name for a light style next button with circular frame
	private static let imageNextLightCircle = "TRIKButtonNextLightCircle.png"
	
	/// Image name for a light style next button with rectangular frame
	private static let imageNextLightRect = "TRIKButtonNextLightRect.png"
	
	/// Image name for a light style next button with rounded rectangular frame
	private static let imageNextLightRoundedRect = "TRIKButtonNextLightRoundedRect.png"
	
	/// Image name for a dark style previous button with circular frame
	private static let imagePreviousDarkCircle = "TRIKButtonPreviousDarkCircle.png"
	
	/// Image name for a dark style previous button with rectangular frame
	private static let imagePreviousDarkRect = "TRIKButtonPreviousDarkRect.png"
	
	/// Image name for a dark style previous button with rounded rectangular frame
	private static let imagePreviousDarkRoundedRect = "TRIKButtonPreviousDarkRoundedRect.png"
	
	/// Image name for a light style previous button with circular frame
	private static let imagePreviousLightCircle = "TRIKButtonPreviousLightCircle.png"
	
	/// Image name for a light style previous button with rectangular frame
	private static let imagePreviousLightRect = "TRIKButtonPreviousLightRect.png"
	
	/// Image name for a light style previous button with rounded rectangular frame
	private static let imagePreviousLightRoundedRect = "TRIKButtonPreviousLightRoundedRect.png"
	
	/// Standard padding around the overlay's activity indicator
	internal static let indicatorPadding: CGFloat = 3.0
	
	/// Minimum height of the overlay (+ padding)
	internal static let minHeight: CGFloat = {
		var size: CGSize = CGSize(width: 250.0, height: 250.0)
		if let winSize = UIApplication.shared.keyWindow?.bounds.size {
			size = winSize
		}
		return min(size.width, size.height) - TRIKOverlay.padding * 6
	}()
	
	/// Minimum width of the overlay (+ padding)
	internal static let minWidth: CGFloat = TRIKImageSlideShowOverlay.minHeight

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Alpha level of the overlay's buttons
	internal var buttonAlpha: TRIKImageSlideShowOverlay.ButtonAlphaLevel
	
	/// Button style of the overlay
	private var buttonStyleStored: TRIKImageSlideShowOverlay.ButtonStyle!
	internal var buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle {
		get {
			return self.buttonStyleStored
		}
		set {
			if self.buttonStyleStored == nil || newValue != self.buttonStyleStored {
				self.buttonStyleStored = newValue
				
				let colors = self.determineIndicatorColors()
				let imageNames = self.determineButtonImageNames()
				
				if self.isDismissable, let button = self.dismissButton {
					button.setBackgroundImage(UIImage(named: imageNames.dismiss, in: TRIKUtil.trikResourceBundle(), compatibleWith: nil), for: .normal)
				}
				
				if let indicator = self.indicator, let container = self.indicatorContainerView {
					indicator.color = colors.indicator
					container.backgroundColor = colors.container
				}
				
				if let button = self.previousImageButton {
					button.setBackgroundImage(UIImage(named: imageNames.previous, in: TRIKUtil.trikResourceBundle(), compatibleWith: nil), for: .normal)
				}
				
				if let button = self.nextImageButton {
					button.setBackgroundImage(UIImage(named: imageNames.next, in: TRIKUtil.trikResourceBundle(), compatibleWith: nil), for: .normal)
				}
			}
		}
	}
	
	/// Index or indices of the currently displayed image(s) within the overlay's array of images
	internal var currentImageIndices: (first: Int, second: Int?)
	
	// The overlay's delegate, responsible for reacting to dismissal of the overlay
	public var delegate: TRIKImageSlideShowOverlayDelegate?
	
	/// Dismisses the overlay
	private var dismissButton: UIButton?
	
	/// Contains the file paths of all images that should be displayed in the overlay
	public var imagePaths: [String]? {
		didSet {
			if self.imagePaths != nil {
				self.imagesPreloaded = false
				self.images = nil
				self.resetPagingFunctionality()
			}
		}
	}
	
	/// Contains all images that should be displayed in the overlay
	public var images: [UIImage]? {
		didSet {
			if self.images != nil {
				self.imagesPreloaded = true
				self.imagePaths = nil
				self.resetPagingFunctionality()
			}
		}
	}
	
	/// Flag about whether or not the overlay works with image paths or preloaded images
	internal var imagesPreloaded: Bool!
	
	/// Displayed while an image is loading
	private var indicator: UIActivityIndicatorView?
	
	/// Container view of the overlay's activity indicator
	internal var indicatorContainerView: UIView?
	
	/// Flag about whether or not the overlay shows a dismiss button
	internal private (set) var isDismissable: Bool
	
	/// Shows the next image in the overlay
	internal var nextImageButton: UIButton?
	
	/// Flag about whether or not the overlay shows paging buttons
	internal private (set) var pagingButtonsEnabled: Bool
	
	/// Shows the previous image in the overlay
	internal var previousImageButton: UIButton?

	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKImageSlideShowOverlay.self)), but will always return nil.
			Either use init(imagePaths:
							superview:
							font:
							style:
							position:
							buttonStyle:
							buttonAlpha:
							dismissButtonEnabled:
							pagingButtonsEnabled:
							delegate:)
			or init(images:
					superview:
					font:
					style:
					position:
					buttonStyle:
					buttonAlpha:
					dismissButtonEnabled:
					pagingButtonsEnabled:
					delegate:)
			instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the image slide show overlay, when images should be loaded on demand.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- paths: Array containing the file paths of all images that should be displayed in the overlay
		- superview: The overlay's designated superview
		- font: The font to use within the overlay
		- style: The style of the overlay
		- buttonStyle: The style of the overlay's buttons
		- buttonAlpha: The visibility level of the overlay's buttons
		- position: The position of the overlay in its superview
		- dismissButtonEnabled: Flag about whether or not the overlay can be dismissed via a dismiss button
		- pagingButtonsEnabled: Flag about whether or not the overlay shows paging buttons
		- delegate: The overlay's delegate
	
	- returns: A fully set up instance of TRIKImageSlideShowOverlay
	*/
	public convenience init(imagePaths paths: [String],
							superview: UIView,
							font: UIFont = TRIKOverlay.defaultFont,
							style: TRIKOverlay.Style = .white,
							position: TRIKOverlay.Position = .center,
							buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle = .roundedRect,
							buttonAlpha: TRIKImageSlideShowOverlay.ButtonAlphaLevel = .full,
							dismissButton dismissButtonEnabled: Bool = true,
							pagingButtons pagingButtonsEnabled: Bool = true,
							delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.init(superview: superview,
				  font: font,
				  style: style,
				  position: position,
				  buttonStyle: buttonStyle,
				  buttonAlpha: buttonAlpha,
				  dismissButton: dismissButtonEnabled,
				  pagingButtons: pagingButtonsEnabled,
				  delegate: delegate)
		
		self.imagePaths = paths
		self.imagesPreloaded = false
		
		self.setupOverlay()
	}
	
	/**
	The designated initializer of the image slide show overlay, when images should be preloaded.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- images: Array containing the images that should be displayed in the overlay
		- superview: The overlay's designated superview
		- font: The font to use within the overlay
		- style: The style of the overlay
		- buttonStyle: The style of the overlay's buttons
		- buttonAlpha: The visibility level of the overlay's buttons
		- position: The position of the overlay in its superview
		- dismissButtonEnabled: Flag about whether or not the overlay can be dismissed via a dismiss button
		- pagingButtonsEnabled: Flag about whether or not the overlay shows paging buttons
		- delegate: The overlay's delegate
	
	- returns: A fully set up instance of TRIKImageSlideShowOverlay
	*/
	public convenience init(images: [UIImage],
							superview: UIView,
							font: UIFont = TRIKOverlay.defaultFont,
							style: TRIKOverlay.Style = .white,
							position: TRIKOverlay.Position = .center,
							buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle = .roundedRect,
							buttonAlpha: TRIKImageSlideShowOverlay.ButtonAlphaLevel = .full,
							dismissButton dismissButtonEnabled: Bool = true,
							pagingButtons pagingButtonsEnabled: Bool = true,
							delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.init(superview: superview,
				  font: font,
				  style: style,
				  position: position,
				  buttonStyle: buttonStyle,
				  buttonAlpha: buttonAlpha,
				  dismissButton: dismissButtonEnabled,
				  pagingButtons: pagingButtonsEnabled,
				  delegate: delegate)
		
		self.images = images
		self.imagesPreloaded = true
		
		self.setupOverlay()
	}
	
	/**
	Private initializer of the image slide show overlay that is only used by the overlay's convenience initializers.
	
	- parameters:
		- superview: The overlay's designated superview
		- font: The font to use within the overlay
		- style: The style of the overlay
		- buttonStyle: The style of the overlay's buttons
		- buttonAlpha: The visibility level of the overlay's buttons
		- position: The position of the overlay in its superview
		- dismissButtonEnabled: Flag about whether or not the overlay can be dismissed via a dismiss button
		- pagingButtonsEnabled: Flag about whether or not the overlay shows paging buttons
		- delegate: The overlay's delegate
	
	- returns: Instance of TRIKImageSlideShowOverlay, ready for setup
	*/
	internal init(superview: UIView,
				  font: UIFont = TRIKOverlay.defaultFont,
				  style: TRIKOverlay.Style,
				  position: TRIKOverlay.Position,
				  buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle,
				  buttonAlpha: TRIKImageSlideShowOverlay.ButtonAlphaLevel = .full,
				  dismissButton dismissButtonEnabled: Bool = true,
				  pagingButtons pagingButtonsEnabled: Bool = true,
				  delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.buttonAlpha = buttonAlpha
		self.isDismissable = dismissButtonEnabled
		self.pagingButtonsEnabled = pagingButtonsEnabled
		self.delegate = delegate
		self.currentImageIndices = (first: 0, second: nil)
		
		super.init(superview: superview,
				   text: TRIKConstant.SpecialString.empty,
				   font: font,
				   style: style,
				   position: position)
		
		// Set button style (possible only after init phase 1 is completed, due to calling self within setter)
		self.buttonStyle = buttonStyle
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
	Moves the overlay's buttons to the front of the overlay.
	*/
	internal func bringButtonsToFront() {
		if let dismiss = self.dismissButton {
			self.bringSubviewToFront(dismiss)
		}
		if let previous = self.previousImageButton {
			self.bringSubviewToFront(previous)
		}
		if let next = self.nextImageButton {
			self.bringSubviewToFront(next)
		}
		if let indicatorContainer = self.indicatorContainerView {
			self.bringSubviewToFront(indicatorContainer)
		}
	}
	
	/**
	Presents the overlay, displaying the image specified by index.
	
	Discussion
	-
	This method's implementation is empty (in TRIKImageSlideShowOverlay). The actual functionality is implemented in the overlay's subclasses.
	
	- parameters:
		- index: Index of the image to display
		- animated: Flag about whether or not to animate the presentation
		- completion: Optional completion closure
	*/
	@objc public func presentWithImage(atIndex index: Int, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {}
	
	/**
	Presents the overlay's activity indicator and disables all other interactive subviews.
	*/
	public func presentIndicator() {
		self.indicatorContainerView?.isHidden = false
		self.indicator?.startAnimating()
		
		self.dismissButton?.isEnabled = false
		self.previousImageButton?.isEnabled = false
		self.nextImageButton?.isEnabled = false
	}
	
	/**
	Dismisses the overlay's activity indicator and re-enables all other interactive subviews.
	*/
	public func dismissIndicator() {
		self.indicator?.stopAnimating()
		self.indicatorContainerView?.isHidden = true
		
		self.dismissButton?.isEnabled = true
		self.previousImageButton?.isEnabled = true
		self.nextImageButton?.isEnabled = true
	}
	
	/**
	Displays the previous image in the overlay.
	
	Discussion
	-
	This method's implementation is empty. The actual functionality is implemented in the overlay's subclasses.
	*/
	@objc internal func displayPreviousImage() {}
	
	/**
	Displays the next image in the overlay.
	
	Discussion
	-
	This method's implementation is empty. The actual functionality is implemented in the overlay's subclasses.
	*/
	@objc internal func displayNextImage() {}
	
	/**
	Determines the number of images shown in the overlay subject to whether or not the overlay uses preloaded images.
	
	- returns: Image count
	*/
	internal func getImageCount() -> Int {
		var count: Int = 0
		if self.imagesPreloaded, let images = self.images {
			count = images.count
		}
		else if let paths = self.imagePaths {
			count = paths.count
		}
		
		return count
	}
	
	/**
	Checks whether or not a passed index is valid.
	
	- parameters:
		- index: Index to check for validity
	
	- returns: true, if index is valid, false otherwise
	*/
	internal func isIndexValid(_ index: Int) -> Bool {
		var indexValid = true
		if index < 0 {
			indexValid = false
		}
		else if index >= self.getImageCount() {
			indexValid = false
		}
		
		return indexValid
	}
	
	/**
	Sets the visibility state of the overlay's paging buttons subject to the index of the currently displayed image.
	*/
	internal func setPagingButtonVisibility() {
		let imageCount = self.getImageCount()
		guard self.pagingButtonsEnabled && imageCount > 1 else {
			return
		}
		
		if self.currentImageIndices.first == 0 {
			self.previousImageButton?.isHidden = true
		}
		else {
			self.previousImageButton?.isHidden = false
		}
		
		var nextButtonShouldBeHidden = false
		if let secondIndex = self.currentImageIndices.second, secondIndex == imageCount - 1 {
			nextButtonShouldBeHidden = true
		}
		else if self.currentImageIndices.first == imageCount - 1 {
			nextButtonShouldBeHidden = true
		}
		
		if nextButtonShouldBeHidden {
			self.nextImageButton?.isHidden = true
		}
		else {
			self.nextImageButton?.isHidden = false
		}
	}
	
	/**
	Dismisses and destroys the overlay.
	*/
	@objc private func dismissButtonTapped(_ sender: UIButton) {
		self.delegate?.overlayDidDismiss(self)
		
		self.dismiss(animated: true) { [unowned self] (_) in
			self.destroy()
		}
	}
	
}

// MARK: -
// MARK: Setup und customization
extension TRIKImageSlideShowOverlay {
	/**
	Sets up the overlay.
	*/
	@objc internal func setupOverlay() {
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the layout of the overlay's subviews.
	*/
	private func setupSubviewLayout() {
		// Dismiss button
		if self.isDismissable {
			self.dismissButton = UIButton(type: .custom)
			let button = self.dismissButton!
			button.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(button)
			button.addConstraint(NSLayoutConstraint(item: button,
													attribute: NSLayoutConstraint.Attribute.height,
													relatedBy: NSLayoutConstraint.Relation.equal,
													toItem: nil,
													attribute: NSLayoutConstraint.Attribute.notAnAttribute,
													multiplier: 1.0,
													constant: TRIKImageSlideShowOverlay.buttonSideLength))
			button.addConstraint(NSLayoutConstraint(item: button,
													attribute: NSLayoutConstraint.Attribute.width,
													relatedBy: NSLayoutConstraint.Relation.equal,
													toItem: nil,
													attribute: NSLayoutConstraint.Attribute.notAnAttribute,
													multiplier: 1.0,
													constant: TRIKImageSlideShowOverlay.buttonSideLength))
			self.addConstraint(NSLayoutConstraint(item: button,
												  attribute: NSLayoutConstraint.Attribute.top,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.top,
												  multiplier: 1.0,
												  constant: TRIKOverlay.padding))
			self.addConstraint(NSLayoutConstraint(item: button,
												  attribute: NSLayoutConstraint.Attribute.trailing,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.trailing,
												  multiplier: 1.0,
												  constant: -TRIKOverlay.padding))
		}
		
		// Activity indicator
		self.indicator = UIActivityIndicatorView(style: .whiteLarge)
		self.indicatorContainerView = UIView(frame: CGRect.zero)
		if let indicator = self.indicator, let container = self.indicatorContainerView {
			indicator.translatesAutoresizingMaskIntoConstraints = false
			container.translatesAutoresizingMaskIntoConstraints = false
			container.addSubview(indicator)
			container.addConstraint(NSLayoutConstraint(item: indicator,
													   attribute: NSLayoutConstraint.Attribute.top,
													   relatedBy: NSLayoutConstraint.Relation.equal,
													   toItem: container,
													   attribute: NSLayoutConstraint.Attribute.top,
													   multiplier: 1.0,
													   constant: TRIKImageSlideShowOverlay.indicatorPadding))
			container.addConstraint(NSLayoutConstraint(item: indicator,
													   attribute: NSLayoutConstraint.Attribute.leading,
													   relatedBy: NSLayoutConstraint.Relation.equal,
													   toItem: container,
													   attribute: NSLayoutConstraint.Attribute.leading,
													   multiplier: 1.0,
													   constant: TRIKImageSlideShowOverlay.indicatorPadding))
			container.addConstraint(NSLayoutConstraint(item: indicator,
													   attribute: NSLayoutConstraint.Attribute.centerX,
													   relatedBy: NSLayoutConstraint.Relation.equal,
													   toItem: container,
													   attribute: NSLayoutConstraint.Attribute.centerX,
													   multiplier: 1.0,
													   constant: 0.0))
			container.addConstraint(NSLayoutConstraint(item: indicator,
													   attribute: NSLayoutConstraint.Attribute.centerY,
													   relatedBy: NSLayoutConstraint.Relation.equal,
													   toItem: container,
													   attribute: NSLayoutConstraint.Attribute.centerY,
													   multiplier: 1.0,
													   constant: 0.0))
			
			self.addSubview(container)
			self.addConstraint(NSLayoutConstraint(item: container,
												  attribute: NSLayoutConstraint.Attribute.centerX,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.centerX,
												  multiplier: 1.0,
												  constant: 0.0))
			self.addConstraint(NSLayoutConstraint(item: container,
												  attribute: NSLayoutConstraint.Attribute.centerY,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.centerY,
												  multiplier: 1.0,
												  constant: 0.0))
		}
		
		self.removePagingButtons()
		self.setupPagingButtonLayout()
	}
	
	/**
	Removes the overlay's paging buttons from the overlay.
	*/
	private func removePagingButtons() {
		if let button = self.previousImageButton {
			button.removeFromSuperview()
			self.previousImageButton = nil
		}
		if let button = self.nextImageButton {
			button.removeFromSuperview()
			self.nextImageButton = nil
		}
	}
	
	/**
	Sets up the layout of the overlay's paging buttons.
	*/
	private func setupPagingButtonLayout() {
		if self.pagingButtonsEnabled && self.getImageCount() > 1 {
			// Previous button
			self.previousImageButton = UIButton(type: .custom)
			let pButton = self.previousImageButton!
			pButton.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(pButton)
			pButton.addConstraint(NSLayoutConstraint(item: pButton,
													attribute: NSLayoutConstraint.Attribute.height,
													relatedBy: NSLayoutConstraint.Relation.equal,
													toItem: nil,
													attribute: NSLayoutConstraint.Attribute.notAnAttribute,
													multiplier: 1.0,
													constant: TRIKImageSlideShowOverlay.buttonSideLength))
			pButton.addConstraint(NSLayoutConstraint(item: pButton,
													attribute: NSLayoutConstraint.Attribute.width,
													relatedBy: NSLayoutConstraint.Relation.equal,
													toItem: nil,
													attribute: NSLayoutConstraint.Attribute.notAnAttribute,
													multiplier: 1.0,
													constant: TRIKImageSlideShowOverlay.buttonSideLength))
			self.addConstraint(NSLayoutConstraint(item: pButton,
												  attribute: NSLayoutConstraint.Attribute.leading,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.leading,
												  multiplier: 1.0,
												  constant: TRIKOverlay.padding))
			self.addConstraint(NSLayoutConstraint(item: pButton,
												  attribute: NSLayoutConstraint.Attribute.centerY,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.centerY,
												  multiplier: 1.0,
												  constant: 0.0))
			
			// Next button
			self.nextImageButton = UIButton(type: .custom)
			let nButton = self.nextImageButton!
			nButton.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(nButton)
			nButton.addConstraint(NSLayoutConstraint(item: nButton,
													attribute: NSLayoutConstraint.Attribute.height,
													relatedBy: NSLayoutConstraint.Relation.equal,
													toItem: nil,
													attribute: NSLayoutConstraint.Attribute.notAnAttribute,
													multiplier: 1.0,
													constant: TRIKImageSlideShowOverlay.buttonSideLength))
			nButton.addConstraint(NSLayoutConstraint(item: nButton,
													attribute: NSLayoutConstraint.Attribute.width,
													relatedBy: NSLayoutConstraint.Relation.equal,
													toItem: nil,
													attribute: NSLayoutConstraint.Attribute.notAnAttribute,
													multiplier: 1.0,
													constant: TRIKImageSlideShowOverlay.buttonSideLength))
			self.addConstraint(NSLayoutConstraint(item: nButton,
												  attribute: NSLayoutConstraint.Attribute.trailing,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.trailing,
												  multiplier: 1.0,
												  constant: -TRIKOverlay.padding))
			self.addConstraint(NSLayoutConstraint(item: nButton,
												  attribute: NSLayoutConstraint.Attribute.centerY,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.centerY,
												  multiplier: 1.0,
												  constant: 0.0))
		}
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		let colors = self.determineIndicatorColors()
		let imageNames = self.determineButtonImageNames()
		
		// Dismiss button
		if self.isDismissable {
			if let button = self.dismissButton {
				button.alpha = self.buttonAlpha.rawValue
				button.setBackgroundImage(UIImage(named: imageNames.dismiss, in: TRIKUtil.trikResourceBundle(), compatibleWith: nil), for: .normal)
				button.addTarget(self, action: #selector(TRIKImageSlideShowOverlay.dismissButtonTapped(_:)), for: .touchUpInside)
			}
		}
		
		// Activity indicator
		if let indicator = self.indicator, let container = self.indicatorContainerView {
			indicator.alpha = self.buttonAlpha.rawValue
			indicator.color = colors.indicator
			container.backgroundColor = colors.container
			container.layer.cornerRadius = TRIKOverlay.cornerRadius
			container.isHidden = true
		}
		
		self.customizePagingButtons()
	}
	
	/**
	Customizes the overlay's paging buttons.
	*/
	private func customizePagingButtons() {
		let imageNames = self.determineButtonImageNames()
		
		if let button = self.previousImageButton {
			button.alpha = self.buttonAlpha.rawValue
			button.setBackgroundImage(UIImage(named: imageNames.previous, in: TRIKUtil.trikResourceBundle(), compatibleWith: nil), for: .normal)
			button.addTarget(self, action: #selector(TRIKImageSlideShowOverlay.displayPreviousImage), for: .touchUpInside)
		}
		
		if let button = self.nextImageButton {
			button.alpha = self.buttonAlpha.rawValue
			button.setBackgroundImage(UIImage(named: imageNames.next, in: TRIKUtil.trikResourceBundle(), compatibleWith: nil), for: .normal)
			button.addTarget(self, action: #selector(TRIKImageSlideShowOverlay.displayNextImage), for: .touchUpInside)
		}
	}
	
	/**
	Determines the colors used for the the overlay's activity indicator subject to the overlay's style.
	
	- returns: A tuple containing the colors for the overlay's indicator
	*/
	internal func determineIndicatorColors() -> (indicator: UIColor, container: UIColor) {
		var colors: (indicator: UIColor, container: UIColor)
		
		switch self.style {
		case .white, .light, .tiemzyar:
			colors.indicator = TRIKConstant.Color.white
			colors.container = UIColor(white: 0.0, alpha: self.buttonAlpha.rawValue)
		case .dark, .black:
			colors.indicator = TRIKConstant.Color.black
			colors.container = UIColor(white: 1.0, alpha: self.buttonAlpha.rawValue)
		}
		
		return colors
	}
	
	/**
	Determines the names of the images used within the overlay's buttons subject to the overlay's style and button style.
	
	- returns: A tuple containing the image names for the overlay's buttons
	*/
	private func determineButtonImageNames() -> (dismiss: String, previous: String, next: String) {
		var imageNames: (dismiss: String, previous: String, next: String)
		
		switch self.style {
		case .white, .light, .tiemzyar:
			switch self.buttonStyleStored ?? .roundedRect {
			case .circle:
				imageNames.dismiss = TRIKImageSlideShowOverlay.imageDismissLightCircle
				imageNames.previous = TRIKImageSlideShowOverlay.imagePreviousLightCircle
				imageNames.next = TRIKImageSlideShowOverlay.imageNextLightCircle
			case .rect:
				imageNames.dismiss = TRIKImageSlideShowOverlay.imageDismissLightRect
				imageNames.previous = TRIKImageSlideShowOverlay.imagePreviousLightRect
				imageNames.next = TRIKImageSlideShowOverlay.imageNextLightRect
			default:
				imageNames.dismiss = TRIKImageSlideShowOverlay.imageDismissLightRoundedRect
				imageNames.previous = TRIKImageSlideShowOverlay.imagePreviousLightRoundedRect
				imageNames.next = TRIKImageSlideShowOverlay.imageNextLightRoundedRect
			}
		case .dark, .black:
			switch self.buttonStyleStored ?? .roundedRect {
			case .circle:
				imageNames.dismiss = TRIKImageSlideShowOverlay.imageDismissDarkCircle
				imageNames.previous = TRIKImageSlideShowOverlay.imagePreviousDarkCircle
				imageNames.next = TRIKImageSlideShowOverlay.imageNextDarkCircle
			case .rect:
				imageNames.dismiss = TRIKImageSlideShowOverlay.imageDismissDarkRect
				imageNames.previous = TRIKImageSlideShowOverlay.imagePreviousDarkRect
				imageNames.next = TRIKImageSlideShowOverlay.imageNextDarkRect
			default:
				imageNames.dismiss = TRIKImageSlideShowOverlay.imageDismissDarkRoundedRect
				imageNames.previous = TRIKImageSlideShowOverlay.imagePreviousDarkRoundedRect
				imageNames.next = TRIKImageSlideShowOverlay.imageNextDarkRoundedRect
			}
		}
		
		return imageNames
	}
	
	/**
	Removes the overlay's paging buttons and re-adds them to the overlay, subject to the number of images to display in the overlay.
	*/
	private func resetPagingFunctionality() {
		self.removePagingButtons()
		self.setupPagingButtonLayout()
		self.customizePagingButtons()
	}
}
