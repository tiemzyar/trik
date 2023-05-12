//
//  TRIKZoomableImage.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 20.11.18.
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
Custom UIScrollView implementation for zooming in and out on an image using gesture recognizers.

Zoom functionality:
- Pinch: Zoom in or out gradually
- Single touch double tap: Zoom in by a specific factor
- Dual touch double tap: Zoom out by a specific factor
*/
public class TRIKZoomableImage: UIScrollView {
	// MARK: Nested types


	// MARK: Type properties
	/// Zoom factor for double tap zoom gestures
	private static let zoomFactor: CGFloat = 3.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Constraint for the leading alignment of the zoomable image's image
	private var constraintImageLeading: NSLayoutConstraint?
	
	/// Constraint for the trailing alignment of the zoomable image's image
	private var constraintImageTrailing: NSLayoutConstraint?
	
	/// Constraint for the top alignment of the zoomable image's image
	private var constraintImageTop: NSLayoutConstraint?
	
	/// Constraint for the bottom	 alignment of the zoomable image's image
	private var constraintImageBottom: NSLayoutConstraint?
	
	/// Index of the image shown in the zoomable image (used in slide shows)
	public var imageIndex: Int = 0
	
	/// The zoomable image's image
	internal private (set) var imageView: UIImageView

	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKZoomableImage.self)), but will always return nil.
			Use init(frame:) instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the zoomable image.
	
	Initializes the zoomable image and adds gesture recognizers for double tap zoom functionality to it.
	
	- parameters:
		- frame: Dimensions of the zoomable image
	
	- returns: Fully set up instance of TRIKZoomableImage
	*/
	override public init(frame: CGRect) {
		self.imageView = UIImageView(frame: frame)
		
		super.init(frame: frame)
		
		self.setup()
	}
	
	/**
	Positions the zoomable image's image correctly.
	*/
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		let boundsSize = self.bounds.size
		var frameToCenter = self.imageView.frame

		// Center horizontally
		if frameToCenter.size.width < boundsSize.width {
			frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
		}
		else {
			frameToCenter.origin.x = 0
		}

		// Center vertically
		if frameToCenter.size.height < boundsSize.height {
			frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
		}
		else {
			frameToCenter.origin.y = 0
		}

		self.imageView.frame = frameToCenter
		self.updateImageConstraints()
		self.updateImageZoomScales()
	}

	// MARK: -
	// MARK: Instance methods
	/**
	Displays the specified image in the zoomable image.
	
	- parameters:
		- image: Image to display
		- completion: Optional completion closure
			(default: nil)
	*/
	public func displayImage(_ image: UIImage, completion: ((Bool) -> Void)? = nil) {
		// Reset the zoomable image's zoom scale to 1.0 before any calulations
		self.zoomScale = 1.0
		
		// Set new image
		self.imageView.image = image
		let imageWidthSmallerThanSelf = self.bounds.size.width > self.imageView.image!.size.width
		let imageHeightSmallerThanSelf = self.bounds.size.height > self.imageView.image!.size.height
		if imageWidthSmallerThanSelf && imageHeightSmallerThanSelf {
			self.imageView.contentMode = .center
		}
		else {
			self.imageView.contentMode = .scaleAspectFit
		}
		
		self.updateImageConstraints()
		self.updateImageZoomScales()
		self.zoomScale = self.minimumZoomScale
		
		completion?(true)
	}
}

// MARK: -
// MARK: Setup und customization
extension TRIKZoomableImage {
	/**
	Sets up the zoomable image.
	*/
	private func setup() {
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the layout of the zoomable image's subviews.
	*/
	private func setupSubviewLayout() {
		// Image view
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.imageView)
		
		self.constraintImageTop = self.imageView.topAnchor.constraint(equalTo: self.topAnchor)
		self.constraintImageTop?.isActive = true
		self.constraintImageLeading = self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
		self.constraintImageLeading?.isActive = true
		self.constraintImageTrailing = self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		self.constraintImageTrailing?.isActive = true
		self.constraintImageBottom = self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		self.constraintImageBottom?.isActive = true
	}
	
	/**
	Customizes the zoomable image and its subviews.
	*/
	private func customize() {
		self.backgroundColor = TRIKConstant.Color.clear
		self.bouncesZoom = true
		self.decelerationRate = UIScrollView.DecelerationRate.fast
		self.delegate = self
		self.showsHorizontalScrollIndicator = false
		self.showsVerticalScrollIndicator = false
		
		// Gesture recognizers for zooming
		var doubleTapZoom = UITapGestureRecognizer(target: self,
												   action: #selector(TRIKZoomableImage.doubleTapZoomIn(_:)))
		doubleTapZoom.numberOfTapsRequired = 2
		doubleTapZoom.numberOfTouchesRequired = 1
		self.addGestureRecognizer(doubleTapZoom)
		
		doubleTapZoom = UITapGestureRecognizer(target: self,
											   action: #selector(TRIKZoomableImage.doubleTapZoomOut(_:)))
		doubleTapZoom.numberOfTapsRequired = 2
		doubleTapZoom.numberOfTouchesRequired = 2
		self.addGestureRecognizer(doubleTapZoom)
		
		// Image view
		self.imageView.contentMode = .scaleAspectFit
	}
}

// MARK: -
// MARK: Size changes
extension TRIKZoomableImage {
	/**
	Adjusts the zoomable image's constraints to a passed size.
	
	- parameters:
	- size: Size to which to adjust the zoomable image's constraints
	*/
	private func updateImageConstraints() {
		let yOffset = max(0, (self.bounds.size.height - imageView.frame.height) / 2)
		self.constraintImageTop?.constant = yOffset
		self.constraintImageBottom?.constant = yOffset
		
		let xOffset = max(0, (self.bounds.size.width - imageView.frame.width) / 2)
		self.constraintImageLeading?.constant = xOffset
		self.constraintImageTrailing?.constant = xOffset
		
		self.layoutIfNeeded()
	}
	
	/**
	Calculates the minimum and maximum zoom scale of the zoomable image subject to the bounds of the zoomable image and its image view.
	*/
	private func updateImageZoomScales() {
		guard let image = self.imageView.image else {
			return
		}
		let boundsSize = self.bounds.size
		let imageSize = image.size
		let imageViewSize = self.imageView.bounds.size
		
		// Calulate zoom scales
		var minScale: CGFloat
		var maxScale: CGFloat
		if imageSize.width < boundsSize.width && imageSize.height < boundsSize.height {
			minScale = 1.0
			maxScale = 1.0
		}
		else {
			var xScale = boundsSize.width / imageViewSize.width		// Scale needed to perfectly fit the image regarding its width
			var yScale = boundsSize.height / imageViewSize.height	// Scale needed to perfectly fit the image regarding its height
			minScale = min(xScale, yScale)							// Makes image become fully visible
			
			// Set max zoom scale independet of device display resolution (retina / non-retina)
			xScale = imageSize.width / boundsSize.width
			yScale = imageSize.height / boundsSize.height
			maxScale = max(xScale, yScale)
			
			// Prevent minScale from becoming bigger than maxScale
			// (would force an image that is smaller than the screen to be zoomed to the screen's dimensions)
			if minScale > maxScale {
				minScale = maxScale
			}
		}
		
		self.minimumZoomScale = minScale
		self.maximumZoomScale = maxScale
	}
}

// MARK: -
// MARK: Gesture recognizer conformance and associated methods
extension TRIKZoomableImage: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return true
	}
	
	/**
	On single touch double taps, zooms in on the image currently shown in the zoomable image.
	
	- parameters:
		- recognizer: Gesture recognizer triggering the method call
	*/
	@objc private func doubleTapZoomIn(_ recognizer: UIGestureRecognizer) {
		if self.zoomScale < self.maximumZoomScale {
			let positionOfTouch = recognizer.location(in: self.imageView)
			let newScale = self.zoomScale * TRIKZoomableImage.zoomFactor > self.maximumZoomScale ? self.maximumZoomScale : self.zoomScale * TRIKZoomableImage.zoomFactor
			let zoomRect = self.zoomRectForScale(newScale, withCenter: positionOfTouch)
			
			self.zoom(to: zoomRect, animated: true)
			self.setZoomScale(newScale, animated: true)
		}
		else {
			self.setZoomScale(self.minimumZoomScale, animated: true)
		}
	}
	
	/**
	On dual touch double taps, zooms out on the image currently shown in the zoomable image.
	
	- parameters:
		- recognizer: Gesture recognizer triggering the method call
	*/
	@objc private func doubleTapZoomOut(_ recognizer: UIGestureRecognizer) {
		if self.zoomScale > self.minimumZoomScale {
			let positionOfTouch = recognizer.location(in: self.imageView)
			let newScale = self.zoomScale / TRIKZoomableImage.zoomFactor < self.minimumZoomScale ? self.minimumZoomScale : self.zoomScale / TRIKZoomableImage.zoomFactor
			let zoomRect = self.zoomRectForScale(newScale, withCenter: positionOfTouch)
			
			self.zoom(to: zoomRect, animated: true)
			self.setZoomScale(newScale, animated: true)
		}
		else {
			self.setZoomScale(self.maximumZoomScale, animated: true)
		}
	}
	
	/**
	Calculates a zoom rectangle subject to a given scale and center point.
	
	- parameters:
		- scale: Scale for the zoom rectangle
		- point: Center point of the zoom rectangle
	*/
	private func zoomRectForScale(_ scale: CGFloat, withCenter center: CGPoint) -> CGRect {
		// Set the zoom rectangle's dimensions subject to the zoomable image's dimensions and scale
		let size = CGSize(width: self.bounds.size.width / scale,
						  height: self.bounds.size.height / scale)
		
		// Set the zoom rectangle's origin subject to center
		let origin = CGPoint(x: center.x - (size.width  / 2.0),
							 y: center.y - (size.height / 2.0))
		
		return CGRect(origin: origin, size: size)
	}
}

// MARK: -
// MARK: Scroll view delegate conformance
extension TRIKZoomableImage: UIScrollViewDelegate {
	/**
	Makes the zoomable image zoom the currently shown image on pinch gestures.
	
	- parameters:
		- scrollView: The zoomable image
	
	- returns: The zoomable image's image view
	*/
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
	
	/**
	Update the zoomable image's constraints.
	
	- parameters:
		- scrollView: The zoomable image
	*/
	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		self.updateImageConstraints()
	}
}

// MARK: -
// MARK: Legacy methods (from Objective-C version; keeping for reference)
extension TRIKZoomableImage {
	/**
	Adjusts the zoomable image's content offset and scale to try preserving the old zoom scale and center.
	
	- parameters:
	- point: Old center point of the zoomable image
	- scale: Old zoom scale of the zoomable image
	*/
	private func restoreCenterPoint(_ point: CGPoint, forScale scale: CGFloat) {
	// Step 1: Restore the zoom scale, first making sure it is within the allowable range.
	self.zoomScale = min(self.maximumZoomScale, max(self.minimumZoomScale, scale))
	
	// Step 2: Restore the center point, first making sure it is within the allowable range
	// 2a: Convert the desired center point back to the slide show image's coordinate space
	let boundsCenter = self.convert(point, from: self.imageView)
	// 2b: Calculate the content offset that would yield that center point
	var offset = CGPoint(x: boundsCenter.x - self.bounds.size.width / 2.0,
	y: boundsCenter.y - self.bounds.size.height / 2.0)
	// 2c: Restore the offset, adjusted to be within the allowable range
	let maxOffset = self.maximumContentOffset()
	let minOffset = self.minimumContentOffset()
	offset.x = max(minOffset.x, min(maxOffset.x, offset.x))
	offset.y = max(minOffset.y, min(maxOffset.y, offset.y))
	self.contentOffset = offset
	}
	
	/**
	Retrieves the maximum content offset of the zoomable image subject to the zoomable image's content size and bounds.
	
	- returns: Point for the maximum offset
	*/
	private func maximumContentOffset() -> CGPoint {
		let contentSize = self.contentSize
		let boundsSize = self.bounds.size
		
		return CGPoint(x: contentSize.width - boundsSize.width,
					   y: contentSize.height - boundsSize.height)
	}
	
	/**
	Retrieves the minimum content offset of the zoomable image.
	
	- returns: Zero point
	*/
	private func minimumContentOffset() -> CGPoint {
		return CGPoint.zero
	}
	
	private func pointToCenter() -> CGPoint {
		let boundsCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		
		return self.convert(boundsCenter, to: self.imageView)
	}
	
	private func scaleToRestore() -> CGFloat {
		var contentScale = self.zoomScale
		
		// If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum allowable scale when the scale is restored
		if contentScale <= self.minimumZoomScale + CGFloat(Float.ulpOfOne) {
			contentScale = 0.0
		}
		
		return contentScale
	}
}
