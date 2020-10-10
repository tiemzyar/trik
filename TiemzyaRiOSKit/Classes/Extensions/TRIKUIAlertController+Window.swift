//
//  TRIKUIAlertController+Window.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 09.10.18.
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

import Foundation
import UIKit

/**
Extension of UIAlertController for presentation within a dedicated UIWindow instance.

Discussion
-
See http://stackoverflow.com/a/30941356 for additional information.

Metadata
-
Author: tiemzyar

Revision history:
- Created extension
*/
public extension UIAlertController {
	/// Contains the necessary keys for using associated objects
	private struct AssociatedKeys {
		static var alertWindow = "trikAlertWindow"
		static var sourceView = "trikSourceView"
	}
	
	/// Window for presenting the alert controller
	var alertWindow: UIWindow? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.alertWindow) as? UIWindow
		}
		set {
			objc_setAssociatedObject(
				self,
				&AssociatedKeys.alertWindow,
				newValue as UIWindow?,
				.OBJC_ASSOCIATION_RETAIN_NONATOMIC
			)
		}
	}
	
	/// Source view to which to attach the alert controller (action sheet on iPad only)
	var sourceView: UIView? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.sourceView) as? UIView
		}
		set {
			objc_setAssociatedObject(
				self,
				&AssociatedKeys.sourceView,
				newValue as UIView?,
				.OBJC_ASSOCIATION_RETAIN_NONATOMIC
			)
		}
	}
	
	/**
	Presents the alert controller in a dedicated UIWindow instance.
	
	Parameters:
	- animated: Flag about whether or not the alert controller's appearance should be animated
	*/
	func show(animated: Bool = false) {
		NotificationCenter.default.addObserver(forName: TRIKConstant.Notification.Name.alertVCSizeTransitionCompleted, object: nil, queue: nil) { [weak self] (_) in
			self?.convertPresentationOrigin()
		}
		
		guard let delegate = UIApplication.shared.delegate, let w = delegate.window, let window = w else {
			return
		}
		
		self.alertWindow = UIWindow(frame: window.frame)
		self.alertWindow!.screen = UIScreen.main
		self.alertWindow!.rootViewController = TRIKAlertVC()
		
		// Set window's tintColor (prevents button titles from being illegible due to clear color)
		self.alertWindow!.tintColor = TRIKConstant.Color.Grey.medium
		
		// Set window level to above top window (prevents actionsheets from being hidden behind the keyboard)
		if let windowLevel = UIApplication.shared.windows.last?.windowLevel {
			self.alertWindow!.windowLevel = windowLevel + 1
		}
		else {
			self.alertWindow!.windowLevel = UIWindow.Level.alert
		}
		
		self.convertPresentationOrigin()
		
		self.alertWindow!.makeKeyAndVisible()
		self.alertWindow!.rootViewController!.present(self, animated: animated, completion: nil)
	}
	
	/**
	Dismisses the alert controller by hiding and removing its presentation window.
	*/
	func dismiss() {
		if self.alertWindow != nil {
			self.dismiss(animated: true, completion: {
				self.alertWindow!.isHidden = true
				self.alertWindow = nil
			})
		}
	}
	
	/**
	If the alert controller is presented as popover (i.e. on an iPad), converts the frames of the controller's presentation sources (sourceView or barButtonItem) to the coordinate space of the controller's alert window.
	*/
	private func convertPresentationOrigin() {
		guard let ppc = self.popoverPresentationController,
			let window = self.alertWindow,
			let rootView = window.rootViewController?.view else {
			return
		}
		
		var convertedSourceView: UIView? = nil
		if self.sourceView != nil {
			let origin = self.convertOrigin(ofView: self.sourceView!, toView: rootView)
			let size = self.sourceView!.frame.size
			convertedSourceView = UIView(frame: CGRect(origin: origin, size: size))
		}
		else if let view = ppc.sourceView {
			self.sourceView = view
			let origin = self.convertOrigin(ofView: view, toView: rootView)
			let size = view.frame.size
			convertedSourceView = UIView(frame: CGRect(origin: origin, size: size))
		}
		else if let view = ppc.barButtonItem?.value(forKey: "view") as? UIView {
			self.sourceView = view
			let origin = self.convertOrigin(ofView: view, toView: rootView)
			let size = view.frame.size
			convertedSourceView = UIView(frame: CGRect(origin: origin, size: size))
			// Setting to nil is necessary, as bar button item takes precedence over source view
			ppc.barButtonItem = nil
		}
		
		if let srcView = convertedSourceView {
			srcView.backgroundColor = TRIKConstant.Color.clear
			srcView.translatesAutoresizingMaskIntoConstraints = false
			rootView.translatesAutoresizingMaskIntoConstraints = false
			rootView.addSubview(srcView)
			srcView.addConstraint(NSLayoutConstraint(item: srcView,
			                                         attribute: NSLayoutConstraint.Attribute.width,
			                                         relatedBy: NSLayoutConstraint.Relation.equal,
			                                         toItem: nil,
			                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
			                                         multiplier: 1.0,
			                                         constant: srcView.frame.size.width))
			srcView.addConstraint(NSLayoutConstraint(item: srcView,
			                                         attribute: NSLayoutConstraint.Attribute.height,
			                                         relatedBy: NSLayoutConstraint.Relation.equal,
			                                         toItem: nil,
			                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
			                                         multiplier: 1.0,
			                                         constant: srcView.frame.size.height))
			rootView.addConstraint(NSLayoutConstraint(item: srcView,
			                                                   attribute: NSLayoutConstraint.Attribute.top,
			                                                   relatedBy: NSLayoutConstraint.Relation.equal,
			                                                   toItem: rootView,
			                                                   attribute: NSLayoutConstraint.Attribute.top,
			                                                   multiplier: 1.0,
			                                                   constant: srcView.frame.origin.y))
			rootView.addConstraint(NSLayoutConstraint(item: srcView,
			                                                   attribute: NSLayoutConstraint.Attribute.leading,
			                                                   relatedBy: NSLayoutConstraint.Relation.equal,
			                                                   toItem: rootView,
			                                                   attribute: NSLayoutConstraint.Attribute.leading,
			                                                   multiplier: 1.0,
			                                                   constant: srcView.frame.origin.x))
			
			ppc.sourceView = srcView
			ppc.sourceRect = srcView.bounds
		}
	}
	
	/**
	Converts the origin of a source view through its entire superview hierarchy (including its UIWindow) to the view of another UIWindow instance's root view controller.
	
	Discussion
	-
	destView must comply with the following requirements:
	- It must reside in another UIWindow instance as srcView
	- It must be the view of its UIWindow instance's root view controller.
	
	- parameters:
		- srcView: Source view, residing in one UIWindow instance, whose origin should be converted
		- destView: View of another UIWindow instance's root view controller, to whose coordinate system the source view's origin should be converted
	
	- returns: Converted origin
	*/
	private func convertOrigin(ofView srcView: UIView, toView destView: UIView) -> CGPoint {
		var convertedOrigin = srcView.bounds.origin
		var superview: UIView? = srcView.superview
		var newSrcView: UIView = srcView
		while superview != nil && superview as? UIWindow == nil {
			convertedOrigin = newSrcView.convert(convertedOrigin, to: superview)
			newSrcView = superview!
			superview = superview!.superview
		}
		
		return newSrcView.convert(convertedOrigin, to: destView)
	}
}
