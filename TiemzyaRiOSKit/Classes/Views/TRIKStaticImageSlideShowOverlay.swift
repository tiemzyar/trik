//
//  TRIKStaticImageSlideShowOverlay.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 21.11.18.
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
import MobileCoreServices

// MARK: -
// MARK: Implementation
/**
An overlay for presenting a static slide show of zoomable images.

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKStaticImageSlideShowOverlay: TRIKImageSlideShowOverlay {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Displays the overlay's images
	private var currentImage: TRIKZoomableImage
	
	override public var imagePaths: [String]? {
		didSet {
			if self.imagePaths != nil {
				self.resetSlideShow()
			}
		}
	}
	
	override public var images: [UIImage]? {
		didSet {
			if self.images != nil {
				self.resetSlideShow()
			}
		}
	}
	
	/// Gesture recognizer for left-swipe gestures
	private var swipeLeft: UISwipeGestureRecognizer?
	
	/// Gesture recognizer for right-swipe gestures
	private var swipeRight: UISwipeGestureRecognizer?

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
	
	override internal init(superview: UIView,
						   font: UIFont = TRIKOverlay.defaultFont,
						   style: TRIKOverlay.Style,
						   position: TRIKOverlay.Position,
						   buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle,
						   buttonAlpha: TRIKImageSlideShowOverlay.ButtonAlphaLevel = .full,
						   dismissButton dismissButtonEnabled: Bool = true,
						   pagingButtons pagingButtonsEnabled: Bool = true,
						   delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.currentImage = TRIKZoomableImage(frame: CGRect.zero)
		
		super.init(superview: superview,
				   font: font,
				   style: style,
				   position: position,
				   buttonStyle: buttonStyle,
				   buttonAlpha: buttonAlpha,
				   dismissButton: dismissButtonEnabled,
				   pagingButtons: pagingButtonsEnabled,
				   delegate: delegate)
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
	override public func present(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
		self.presentWithImage(atIndex: 0, animated: animated, completion: completion)
	}

	override public func presentWithImage(atIndex index: Int, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
		super.present(animated: animated) { [unowned self] (_) in
			self.displayImage(atIndex: index)
			completion?(true)
		}
	}
	
	/**
	Sets the overlay's image indices, if the passed index is valid.
	
	- parameters:
		- index: Index of an image to display
	
	- returns: true, if the indices could be set, false, if index is invalid
	*/
	private func setIndices(forImageIndex index: Int) -> Bool {
		let indexValid = self.isIndexValid(index)
		
		if indexValid {
			self.currentImageIndices = (first: index, second: nil)
		}
		
		return indexValid
	}
	
	/**
	Displays the image specified by index in the overlay.
	
	- parameters:
		- index: Index of the image to display
	*/
	private func displayImage(atIndex index: Int) {
		if self.setIndices(forImageIndex: index) {
			self.presentIndicator()
			
			DispatchQueue.global(qos: .default).async {
				var image: UIImage? = nil
				if self.imagesPreloaded, let images = self.images {
					image = images[self.currentImageIndices.first]
				}
				else if let paths = self.imagePaths {
					let pathURL = URL(fileURLWithPath: paths[self.currentImageIndices.first])
					let fileExtension = pathURL.pathExtension as CFString
					let unmanagedFileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
					if let fileUTI = unmanagedFileUTI?.takeRetainedValue() {
						if UTTypeConformsTo(fileUTI, kUTTypeImage) {
							image = UIImage(contentsOfFile: pathURL.path)
						}
					}
				}
				
				if image == nil {
					image = TRIKImageSlideShowOverlay.dummyImage
				}
				
				DispatchQueue.main.async {
					self.setPagingButtonVisibility()
					self.dismissIndicator()
					if let img = image {
						UIView.transition(with: self.currentImage.imageView,
										  duration: TRIKConstant.AnimationTime.long,
										  options: UIViewAnimationOptions.transitionCrossDissolve,
										  animations: {
											self.currentImage.displayImage(img)
						},
										  completion: nil)
					}
				}
			}
		}
	}
	
	/**
	Displays the previous image in the overlay.
	*/
	override internal func displayPreviousImage() {
		self.displayImage(atIndex: self.currentImageIndices.first - 1)
	}
	
	/**
	Displays the next image in the overlay.
	*/
	override internal func displayNextImage() {
		self.displayImage(atIndex: self.currentImageIndices.first + 1)
	}
}

// MARK: -
// MARK: Setup and customization
extension TRIKStaticImageSlideShowOverlay {
	/**
	Sets up the overlay.
	*/
	override internal func setupOverlay() {
		super.setupOverlay()
		
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the layout of the overlay's subviews.
	*/
	private func setupSubviewLayout() {
		self.currentImage.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.currentImage)
		self.bringButtonsToFront()
		self.currentImage.addConstraint(NSLayoutConstraint(item: self.currentImage,
														   attribute: NSLayoutAttribute.width,
														   relatedBy: NSLayoutRelation.greaterThanOrEqual,
														   toItem: nil,
														   attribute: NSLayoutAttribute.notAnAttribute,
														   multiplier: 1.0,
														   constant: TRIKImageSlideShowOverlay.minWidth))
		self.currentImage.addConstraint(NSLayoutConstraint(item: self.currentImage,
														   attribute: NSLayoutAttribute.height,
														   relatedBy: NSLayoutRelation.greaterThanOrEqual,
														   toItem: nil,
														   attribute: NSLayoutAttribute.notAnAttribute,
														   multiplier: 1.0,
														   constant: TRIKImageSlideShowOverlay.minHeight))
		self.addConstraint(NSLayoutConstraint(item: self.currentImage,
											  attribute: NSLayoutAttribute.top,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.top,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.currentImage,
											  attribute: NSLayoutAttribute.leading,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.leading,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.currentImage,
											  attribute: NSLayoutAttribute.trailing,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.trailing,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.currentImage,
											  attribute: NSLayoutAttribute.bottom,
											  relatedBy: NSLayoutRelation.equal,
											  toItem: self,
											  attribute: NSLayoutAttribute.bottom,
											  multiplier: 1.0,
											  constant: 0.0))
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		self.resetGestureRecognizers()
	}
	
	/**
	Resets the overlay's slide show.
	*/
	private func resetSlideShow() {
		self.resetGestureRecognizers()
		self.displayImage(atIndex: 0)
	}
}

// MARK: -
// MARK: Gesture recognizer
extension TRIKStaticImageSlideShowOverlay {
	/**
	Removes all gestore recognizers from the overlay and re-adds them, if the slide show contains more than one image.
	*/
	private func resetGestureRecognizers() {
		// Remove all gesture recognizers from the overlay
		if let left = self.swipeLeft {
			self.removeGestureRecognizer(left)
			self.swipeLeft = nil
		}
		if let right = self.swipeRight {
			self.removeGestureRecognizer(right)
			self.swipeRight = nil
		}
		
		let imageCount = self.getImageCount()
		if imageCount > 1 {
			// Re-add swipe gesture recognizers for swiping to previous respectively next image in the overlay
			self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(TRIKStaticImageSlideShowOverlay.displayNextImage))
			var swipe = self.swipeLeft!
			swipe.direction = .left
			swipe.numberOfTouchesRequired = 1
			self.addGestureRecognizer(swipe)
			
			self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(TRIKStaticImageSlideShowOverlay.displayPreviousImage))
			swipe = self.swipeRight!
			swipe.direction = .right
			swipe.numberOfTouchesRequired = 1
			self.addGestureRecognizer(swipe)
		}
	}
}
