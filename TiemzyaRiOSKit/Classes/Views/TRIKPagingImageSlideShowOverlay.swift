//
//  TRIKPagingImageSlideShowOverlay.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 27.11.18.
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
import MobileCoreServices

// MARK: -
// MARK: Implementation
/**
An overlay for presenting a paging slide show of zoomable images.

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKPagingImageSlideShowOverlay: TRIKImageSlideShowOverlay {
	// MARK: Nested types
	
	
	// MARK: Type properties
	
	
	// MARK: Type methods
	
	
	// MARK: -
	// MARK: Instance properties
	/// Flag about whether or not the overlay shows two images on one page
	internal private (set) var dualImageLayoutEnabled: Bool
	
	override public var imagePaths: [String]? {
		didSet {
			if self.imagePaths != nil && !self.isInitializing {
				self.resetSlideShow()
			}
		}
	}
	
	override public var images: [UIImage]? {
		didSet {
			if self.images != nil && !self.isInitializing {
				self.resetSlideShow()
			}
		}
	}
	
	/// Stores the overlay's stack views (when dual layout enabled)
	private var imageStacks: [UIStackView] = []
	
	/// Flag about whether or not the overlay is currently initializing
	private var isInitializing: Bool
	
	/// Stores the count of images that are already loaded
	private var loadedImageCount: Int = 0
	
	/// The overlay's page label
	private var pageLabel: UILabel
	
	/// Container view of the overlay's page label
	private var pageLabelContainer: UIView
	
	/// The overlay's slide show scroll view
	private var slideShowScrollView: UIScrollView
	
	/// Stores the overlay's zoomable images (zoom container views of all displayed images)
	private var zoomableImages: [TRIKZoomableImage] = []

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
						dismissButton:
						pagingButtons:
						dualImageLayout:
						delegate:)
		or init(images:
				superview:
				font:
				style:
				position:
				buttonStyle:
				buttonAlpha:
				dismissButton:
				pagingButtons:
				dualImageLayout:
				delegate:)
		instead!
		"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the paging image slide show overlay, when images should be loaded on demand.
	
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
		- dualImageLayoutEnabled: Flag about whether or not the overlay shows two images on one page
		- delegate: The overlay's delegate
	
	- returns: A fully set up instance of TRIKPagingImageSlideShowOverlay
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
							dualImageLayout dualImageLayoutEnabled: Bool = true,
							delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.init(superview: superview,
				  font: font,
				  style: style,
				  position: position,
				  buttonStyle: buttonStyle,
				  buttonAlpha: buttonAlpha,
				  dismissButton: dismissButtonEnabled,
				  pagingButtons: pagingButtonsEnabled,
				  dualImageLayout: dualImageLayoutEnabled,
				  delegate: delegate)
		
		self.imagePaths = paths
		self.isInitializing = false
		
		self.setupOverlay()
	}
	
	/**
	The designated initializer of the paging image slide show overlay, when images should be preloaded.
	
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
		- dualImageLayoutEnabled: Flag about whether or not the overlay shows two images on one page
		- delegate: The overlay's delegate
	
	- returns: A fully set up instance of TRIKPagingImageSlideShowOverlay
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
							dualImageLayout dualImageLayoutEnabled: Bool = true,
							delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.init(superview: superview,
				  font: font,
				  style: style,
				  position: position,
				  buttonStyle: buttonStyle,
				  buttonAlpha: buttonAlpha,
				  dismissButton: dismissButtonEnabled,
				  pagingButtons: pagingButtonsEnabled,
				  dualImageLayout: dualImageLayoutEnabled,
				  delegate: delegate)
		
		self.images = images
		self.isInitializing = false
		
		self.setupOverlay()
	}
	
	/**
	Private initializer of the paging image slide show overlay that is only used by the overlay's convenience initializers.
	
	- parameters:
		- superview: The overlay's designated superview
		- font: The font to use within the overlay
		- style: The style of the overlay
		- buttonStyle: The style of the overlay's buttons
		- buttonAlpha: The visibility level of the overlay's buttons
		- position: The position of the overlay in its superview
		- dismissButtonEnabled: Flag about whether or not the overlay can be dismissed via a dismiss button
		- pagingButtonsEnabled: Flag about whether or not the overlay shows paging buttons
		- dualImageLayoutEnabled: Flag about whether or not the overlay shows two images on one page
		- delegate: The overlay's delegate
	
	- returns: Instance of TRIKPagingImageSlideShowOverlay, ready for setup
	*/
	private init(superview: UIView,
				 font: UIFont = TRIKOverlay.defaultFont,
				 style: TRIKOverlay.Style,
				 position: TRIKOverlay.Position,
				 buttonStyle: TRIKImageSlideShowOverlay.ButtonStyle,
				 buttonAlpha: TRIKImageSlideShowOverlay.ButtonAlphaLevel = .full,
				 dismissButton dismissButtonEnabled: Bool = true,
				 pagingButtons pagingButtonsEnabled: Bool = true,
				 dualImageLayout dualImageLayoutEnabled: Bool = true,
				 delegate: TRIKImageSlideShowOverlayDelegate? = nil) {
		self.isInitializing = true
		self.dualImageLayoutEnabled = dualImageLayoutEnabled
		self.slideShowScrollView = UIScrollView(frame: CGRect.zero)
		self.pageLabel = UILabel(frame: CGRect.zero)
		self.pageLabelContainer = UIView(frame: CGRect.zero)
		
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
	
	/**
	Updates the axis of the overlay's stack views.
	*/
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		if self.dualImageLayoutEnabled {
			for stack in self.imageStacks {
				self.determineAxis(forStack: stack)
			}
		}
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
		super.present(animated: true) { (_) in
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
	@discardableResult private func setIndices(forImageIndex index: Int) -> Bool {
		let indexValid = self.isIndexValid(index)
		
		if indexValid {
			/*
			dualImageLayout
				evenImageCount
					evenIndex -> f = index, s = index + 1
					oddIndex -> f = index - 1, s = index
				oddImageCount
					evenIndex -> f = index, s = index + 1
						isLastImageIndex -> f = index, s = nil
					oddIndex -> f = index - 1, s = index
			noDualImageLayout -> f = index, s = nil
			*/
			if self.dualImageLayoutEnabled {
				let imageCount = self.getImageCount()
				let evenImageCount = imageCount % 2 == 0
				let evenIndex = index % 2 == 0
				let isLastImageIndex = index == imageCount - 1
				if evenImageCount {
					if evenIndex {
						self.currentImageIndices = (first: index, second: index + 1)
					}
					else {	// Odd index
						self.currentImageIndices = (first: index - 1 , second: index)
					}
				}
				else {	// Odd image count
					if evenIndex {
						if isLastImageIndex {
							self.currentImageIndices = (first: index, second: nil)
						}
						else {	// Not last image index
							self.currentImageIndices = (first: index, second: index + 1)
						}
					}
					else {	// Odd index
						self.currentImageIndices = (first: index - 1, second: index)
					}
				}
			}
			else {	// No dual image layout
				self.currentImageIndices = (first: index, second: nil)
			}
		}
		
		return indexValid
	}
	
	/**
	Updates the overlay's page label.
	*/
	private func updatePageLabel() {
		let imageCount = self.getImageCount()
		guard imageCount > 0 else {
			return
		}
		
		let incrementIndexToPage = 1
		if let secondIndex = self.currentImageIndices.second {
			self.pageLabel.text = "\(String(format:"%.2d-%.2d/%.2d", self.currentImageIndices.first + incrementIndexToPage, secondIndex + incrementIndexToPage, imageCount))"
		}
		else {
			self.pageLabel.text = "\(String(format:"%.2d/%.2d", self.currentImageIndices.first + incrementIndexToPage, imageCount))"
		}
	}
	
	override internal func displayPreviousImage() {
		var decrement = 1
		if self.dualImageLayoutEnabled {
			decrement = 2
		}
		
		self.displayImage(atIndex: self.currentImageIndices.first - decrement)
	}
	
	override internal func displayNextImage() {
		var increment = 1
		if self.dualImageLayoutEnabled {
			increment = 2
		}
		
		self.displayImage(atIndex: self.currentImageIndices.first + increment)
	}
	
	/**
	Displays the image specified by index in the overlay.
	
	- parameters:
		- index: Index of the image to display
	*/
	private func displayImage(atIndex index: Int) {
		if self.setIndices(forImageIndex: index) {
			self.updateSlideShow()
		}
	}
	
	/**
	Updates the content offset of the overlay's slide show scroll view.
	*/
	public func updateContentOffset() {
		var index = self.currentImageIndices.first
		if self.dualImageLayoutEnabled {
			index /= 2
		}
		
		let visiblePage = self.slideShowScrollView.subviews[index].frame
		self.slideShowScrollView.scrollRectToVisible(visiblePage, animated: false)
	}
	
	/**
	Updates the overlay's slide show scroll view.
	
	- parameters:
		- animated: Flag about whether or not to animate the update
	*/
	private func updateSlideShow(animated: Bool = true) {
		for zImage in self.zoomableImages {
			zImage.zoomScale = zImage.minimumZoomScale
		}
		
		self.updateContentOffset()
		self.setPagingButtonVisibility()
		self.updatePageLabel()
		
		self.fadeInPageLabel { (_) in
			self.fadeOutPageLabel()
		}
	}
	
	/**
	Determines and sets the axis of the passed stack view subject to the overlay's size.
	
	- parameters:
		- stack: Stack view whose axis should be set
	*/
	private func determineAxis(forStack stack: UIStackView) {
		if self.bounds.size.width >= self.bounds.size.height {
			stack.axis = .horizontal
		}
		else {
			stack.axis = .vertical
		}
	}
	
	/**
	Configures the passed image subject to the passed index.
	
	- parameters:
		- zImage: Zoomable image container of the image to configure
		- index: Index of the image to display in zImage
	*/
	private func configureImage(_ zImage: TRIKZoomableImage, forIndex index: Int) {
		DispatchQueue.global(qos: .default).async {
			zImage.imageIndex = index
			
			var image: UIImage? = nil
			if self.imagesPreloaded, let images = self.images {
				image = images[index]
			}
			else if let paths = self.imagePaths {
				let pathURL = URL(fileURLWithPath: paths[index])
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
				if let img = image {
					zImage.displayImage(img)
					self.loadedImageCount += 1
				}
				if self.loadedImageCount == self.zoomableImages.count {
					self.dismissIndicator()
				}
			}
		}
	}
	
	/**
	Fades in the overlay's page label.
	
	- parameters:
		- completion: Optional completion closure
	*/
	private func fadeInPageLabel(withCompletion completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: TRIKConstant.AnimationTime.medium,
					   animations: {
						self.pageLabelContainer.alpha = 1.0
		},
					   completion: completion)
	}
	
	/**
	Fades out the overlay's page label.
	*/
	private func fadeOutPageLabel() {
		UIView.animate(withDuration: TRIKConstant.AnimationTime.medium,
					   animations: {
						self.pageLabelContainer.alpha = 0.0
		},
					   completion: nil)
	}
}

// MARK: -
// MARK: Setup and customization
extension TRIKPagingImageSlideShowOverlay {
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
		// Slide show scroll view
		self.slideShowScrollView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.slideShowScrollView)
		self.bringButtonsToFront()
		self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: self.slideShowScrollView,
																  attribute: NSLayoutConstraint.Attribute.width,
																  relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
																  toItem: nil,
																  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
																  multiplier: 1.0,
																  constant: TRIKImageSlideShowOverlay.minWidth))
		self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: self.slideShowScrollView,
																  attribute: NSLayoutConstraint.Attribute.height,
																  relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
																  toItem: nil,
																  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
																  multiplier: 1.0,
																  constant: TRIKImageSlideShowOverlay.minHeight))
		self.addConstraint(NSLayoutConstraint(item: self.slideShowScrollView,
											  attribute: NSLayoutConstraint.Attribute.top,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.top,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.slideShowScrollView,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.slideShowScrollView,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.slideShowScrollView,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
		self.setupSlideShowLayout()
		
		// Page label
		self.pageLabel.translatesAutoresizingMaskIntoConstraints = false
		self.pageLabelContainer.translatesAutoresizingMaskIntoConstraints = false
		self.pageLabelContainer.addSubview(self.pageLabel)
		self.pageLabelContainer.addConstraint(NSLayoutConstraint(item: self.pageLabel,
																 attribute: NSLayoutConstraint.Attribute.top,
																 relatedBy: NSLayoutConstraint.Relation.equal,
																 toItem: self.pageLabelContainer,
																 attribute: NSLayoutConstraint.Attribute.top,
																 multiplier: 1.0,
																 constant: TRIKOverlay.padding))
		self.pageLabelContainer.addConstraint(NSLayoutConstraint(item: self.pageLabel,
																 attribute: NSLayoutConstraint.Attribute.leading,
																 relatedBy: NSLayoutConstraint.Relation.equal,
																 toItem: self.pageLabelContainer,
																 attribute: NSLayoutConstraint.Attribute.leading,
																 multiplier: 1.0,
																 constant: TRIKOverlay.padding))
		self.pageLabelContainer.addConstraint(NSLayoutConstraint(item: self.pageLabel,
																 attribute: NSLayoutConstraint.Attribute.centerX,
																 relatedBy: NSLayoutConstraint.Relation.equal,
																 toItem: self.pageLabelContainer,
																 attribute: NSLayoutConstraint.Attribute.centerX,
																 multiplier: 1.0,
																 constant: 0.0))
		self.pageLabelContainer.addConstraint(NSLayoutConstraint(item: self.pageLabel,
																 attribute: NSLayoutConstraint.Attribute.centerY,
																 relatedBy: NSLayoutConstraint.Relation.equal,
																 toItem: self.pageLabelContainer,
																 attribute: NSLayoutConstraint.Attribute.centerY,
																 multiplier: 1.0,
																 constant: 0.0))
		self.addSubview(self.pageLabelContainer)
		self.addConstraint(NSLayoutConstraint(item: self.pageLabelContainer,
											  attribute: NSLayoutConstraint.Attribute.top,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.top,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.pageLabelContainer,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
	}
	
	/**
	Sets up the overlay's slide show scroll view.
	*/
	private func setupSlideShowLayout() {
		let imageCount = self.getImageCount()
		
		if self.dualImageLayoutEnabled {
			let evenImageCount = imageCount % 2 == 0
			let stackCount = evenImageCount ? imageCount / 2 : imageCount / 2 + 1
			// Create necessary amount of stacks
			for _ in 0 ..< stackCount {
				let stack = UIStackView()
				stack.translatesAutoresizingMaskIntoConstraints = false
				self.slideShowScrollView.addSubview(stack)
				self.imageStacks.append(stack)
			}
			
			// Add images to stacks
			for index in 0 ..< imageCount {
				let stackIndex = index / 2	// Int division cuts off decimals (= wanted behaviour here)
				
				let image = TRIKZoomableImage(frame: CGRect.zero)
				image.translatesAutoresizingMaskIntoConstraints = false
				self.imageStacks[stackIndex].addArrangedSubview(image)
				self.zoomableImages.append(image)
			}
			
			// Setup stack layout
			for index in 0 ..< self.imageStacks.count {
				let currentStack = self.imageStacks[index]
				if index == 0 {	// Only first stack
					self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentStack,
																			  attribute: NSLayoutConstraint.Attribute.leading,
																			  relatedBy: NSLayoutConstraint.Relation.equal,
																			  toItem: self.slideShowScrollView,
																			  attribute: NSLayoutConstraint.Attribute.leading,
																			  multiplier: 1.0,
																			  constant: 0.0))
				}
				else {	// All other stacks
					let previousStack = self.imageStacks[index - 1]
					self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentStack,
																			  attribute: NSLayoutConstraint.Attribute.leading,
																			  relatedBy: NSLayoutConstraint.Relation.equal,
																			  toItem: previousStack,
																			  attribute: NSLayoutConstraint.Attribute.trailing,
																			  multiplier: 1.0,
																			  constant: 0.0))
				}
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentStack,
																		  attribute: NSLayoutConstraint.Attribute.width,
																		  relatedBy: NSLayoutConstraint.Relation.equal,
																		  toItem: self.slideShowScrollView,
																		  attribute: NSLayoutConstraint.Attribute.width,
																		  multiplier: 1.0,
																		  constant: 0.0))
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentStack,
																		  attribute: NSLayoutConstraint.Attribute.height,
																		  relatedBy: NSLayoutConstraint.Relation.equal,
																		  toItem: self.slideShowScrollView,
																		  attribute: NSLayoutConstraint.Attribute.height,
																		  multiplier: 1.0,
																		  constant: 0.0))
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentStack,
																		  attribute: NSLayoutConstraint.Attribute.top,
																		  relatedBy: NSLayoutConstraint.Relation.equal,
																		  toItem: self.slideShowScrollView,
																		  attribute: NSLayoutConstraint.Attribute.top,
																		  multiplier: 1.0,
																		  constant: 0.0))
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentStack,
																		  attribute: NSLayoutConstraint.Attribute.bottom,
																		  relatedBy: NSLayoutConstraint.Relation.equal,
																		  toItem: self.slideShowScrollView,
																		  attribute: NSLayoutConstraint.Attribute.bottom,
																		  multiplier: 1.0,
																		  constant: 0.0))
			}
			
			// Only last stack
			self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: self.imageStacks[self.imageStacks.count - 1],
																	  attribute: NSLayoutConstraint.Attribute.trailing,
																	  relatedBy: NSLayoutConstraint.Relation.equal,
																	  toItem: self.slideShowScrollView,
																	  attribute: NSLayoutConstraint.Attribute.trailing,
																	  multiplier: 1.0,
																	  constant: 0.0))
		}
		else { // No dual image layout
			var previousImage: TRIKZoomableImage?
			var currentImage: TRIKZoomableImage?
			
			for _ in 0 ..< imageCount {
				currentImage = TRIKZoomableImage(frame: CGRect.zero)
				let cImage = currentImage!
				cImage.translatesAutoresizingMaskIntoConstraints = false
				self.slideShowScrollView.addSubview(cImage)
				self.zoomableImages.append(cImage)
				
				if previousImage == nil {	// Only first image
					self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: cImage,
																			  attribute: NSLayoutConstraint.Attribute.leading,
																			  relatedBy: NSLayoutConstraint.Relation.equal,
																			  toItem: self.slideShowScrollView,
																			  attribute: NSLayoutConstraint.Attribute.leading,
																			  multiplier: 1.0,
																			  constant: 0.0))
				}
				else { // All other images
					let pImage = previousImage!
					self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: cImage,
																			  attribute: NSLayoutConstraint.Attribute.leading,
																			  relatedBy: NSLayoutConstraint.Relation.equal,
																			  toItem: pImage,
																			  attribute: NSLayoutConstraint.Attribute.trailing,
																			  multiplier: 1.0,
																			  constant: 0.0))
				}
				
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: cImage,
													  attribute: NSLayoutConstraint.Attribute.width,
													  relatedBy: NSLayoutConstraint.Relation.equal,
													  toItem: self.slideShowScrollView,
													  attribute: NSLayoutConstraint.Attribute.width,
													  multiplier: 1.0,
													  constant: 0.0))
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: cImage,
													  attribute: NSLayoutConstraint.Attribute.height,
													  relatedBy: NSLayoutConstraint.Relation.equal,
													  toItem: self.slideShowScrollView,
													  attribute: NSLayoutConstraint.Attribute.height,
													  multiplier: 1.0,
													  constant: 0.0))
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: cImage,
																		  attribute: NSLayoutConstraint.Attribute.top,
																		  relatedBy: NSLayoutConstraint.Relation.equal,
																		  toItem: self.slideShowScrollView,
																		  attribute: NSLayoutConstraint.Attribute.top,
																		  multiplier: 1.0,
																		  constant: 0.0))
				self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: cImage,
																		  attribute: NSLayoutConstraint.Attribute.bottom,
																		  relatedBy: NSLayoutConstraint.Relation.equal,
																		  toItem: self.slideShowScrollView,
																		  attribute: NSLayoutConstraint.Attribute.bottom,
																		  multiplier: 1.0,
																		  constant: 0.0))
				
				previousImage = currentImage
			}
			
			// Only last image
			self.slideShowScrollView.addConstraint(NSLayoutConstraint(item: currentImage!,
																	  attribute: NSLayoutConstraint.Attribute.trailing,
																	  relatedBy: NSLayoutConstraint.Relation.equal,
																	  toItem: self.slideShowScrollView,
																	  attribute: NSLayoutConstraint.Attribute.trailing,
																	  multiplier: 1.0,
																	  constant: 0.0))
		}
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		// Slide show scroll view
		self.slideShowScrollView.layer.cornerRadius = TRIKOverlay.cornerRadius
		self.slideShowScrollView.layer.masksToBounds = true
		self.slideShowScrollView.isScrollEnabled = true
		self.slideShowScrollView.isPagingEnabled = true
		self.slideShowScrollView.showsVerticalScrollIndicator = false
		self.slideShowScrollView.showsHorizontalScrollIndicator = false
		self.slideShowScrollView.bounces = false
		self.slideShowScrollView.backgroundColor = TRIKConstant.Color.clear
		self.slideShowScrollView.delegate = self
		
		// Image stacks
		for stack in self.imageStacks {
			self.determineAxis(forStack: stack)
			stack.alignment = .fill
			stack.distribution = .fillEqually
			stack.spacing = TRIKOverlay.subviewSpacing
		}
		
		// Zoomable images
		self.presentIndicator()
		for index in 0 ..< self.zoomableImages.count {
			self.configureImage(self.zoomableImages[index], forIndex: index)
		}
		
		// Page label
		self.pageLabelContainer.alpha = 0.0
		self.pageLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
		self.pageLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
		self.pageLabel.font = self.font
		self.updatePageLabel()
		switch self.style {
		case .white, .light, .tiemzyar:
			self.pageLabelContainer.backgroundColor = UIColor(white: 0.0, alpha: self.buttonAlpha.rawValue)
			self.pageLabel.textColor = TRIKConstant.Color.white
		case .dark, .black:
			self.pageLabelContainer.backgroundColor = UIColor(white: 1.0, alpha: self.buttonAlpha.rawValue)
			self.pageLabel.textColor = TRIKConstant.Color.black
		}
		switch self.buttonStyle {
		case .circle:
			self.pageLabelContainer.layer.cornerRadius = TRIKOverlay.cornerRadius * 3
		case .rect:
			self.pageLabelContainer.layer.cornerRadius = 0.0
		default:
			self.pageLabelContainer.layer.cornerRadius = TRIKOverlay.cornerRadius
		}
		self.pageLabelContainer.layer.masksToBounds = true
		
		// Paging buttons (adjust for dual image layout)
		self.setPagingButtonVisibility()
	}
	
	/**
	Resets the overlay's slide show.
	*/
	private func resetSlideShow() {
		self.displayImage(atIndex: 0)
		
		self.loadedImageCount = 0
		self.imageStacks.removeAll()
		self.zoomableImages.removeAll()
		
		for subview in self.slideShowScrollView.subviews {
			subview.removeFromSuperview()
		}
		self.setupSlideShowLayout()
		self.customize()
		
		self.displayImage(atIndex: 0)
	}
}

// MARK: -
// MARK: Scroll view delegate conformance
extension TRIKPagingImageSlideShowOverlay: UIScrollViewDelegate {
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.fadeInPageLabel()
	}
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let imagesPerPage = self.dualImageLayoutEnabled ? 2 : 1
		
		let svWidth = self.slideShowScrollView.frame.size.width
		let xOffset = self.slideShowScrollView.contentOffset.x
		
		if Int(xOffset) % Int(svWidth) == 0 {
			for zImage in self.zoomableImages {
				zImage.zoomScale = zImage.minimumZoomScale
			}
		}
		
		let imageIndex = Int(ceilf(Float(xOffset) / (Float(svWidth) / Float(imagesPerPage))))
		self.setIndices(forImageIndex: imageIndex)
		
		self.setPagingButtonVisibility()
		self.updatePageLabel()
		self.fadeOutPageLabel()
	}
}
