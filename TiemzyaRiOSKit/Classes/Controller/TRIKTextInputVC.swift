//
//  TRIKTextInputVC.swift
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

// MARK: Imports
import UIKit
import QuartzCore

// MARK: -
// MARK: Implementation
/**
View controller with common functionality of controllers that allow text input by the user.

Metadata:
-
Author: tiemzyar

Revision history:
- Created controller
*/
open class TRIKTextInputVC: TRIKBaseVC, TRIKKeyboardViewAnimationDelegate {
	// MARK: Nested types
	/**
	Enumeration of animation directions.
	
	Cases:
	- up
	- down
	*/
	public enum AnimationDirection {
		case up
		case down
	}

	// MARK: Type properties
	/// Default border color for view layers (CALayer documentation)
	public static let defaultBorderColor = UIColor.black.cgColor
	
	/// Default border width for views
	public static let defaultBorderWidth: CGFloat = 2.0
	
	/// Default text color for text fields in the controller's view
	public static let defaultColor = TRIKConstant.Color.Grey.medium
	
	/// Default font for text fields in the controller's view
	public static let defaultFont = UIFont.systemFont(ofSize: 10.0)
	
	/// Default padding between the system keyboard and the controller's active view
	private static let defaultKeyboardPadding: CGFloat = 50.0
	
	/// Left inset for a left view label of text fields
	private static let labelInsetLeft: CGFloat = -10.0
		
	/// Maximum width for a left view label of text fields
	private static let labelWidthMax: CGFloat =  250.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Currently active view of the controller
	open var activeView: UIView?
	
	/// Stores the distance of view animations, if adjustments to the originally calculated distance were necessary
	private var adjustedDistance: CGFloat? = nil
	
	/// Stores keyboard appearance notifications
	private var keyboardAppearanceNotification: Notification?
	
	/// Stores the keyboard height used for view animation calculations
	private var keyboardHeight: CGFloat = 0.0
	
	/// Stores the padding between the system keyboard and the controller's active view
	open var keyboardPadding: CGFloat = TRIKTextInputVC.defaultKeyboardPadding
	
	/// Stores the reference frame used for view animation calculations
	private var referenceFrame: CGRect = CGRect.zero
	
	/// Flag about whether or not there should be a padding between the system keyboard and the controller's active view
	open var useActiveViewKeyboardPadding: Bool = false
	
	/// Flag about whether or not a view animation is currently active
	private var viewAnimationActive: Bool = false
	
	// MARK: -
	// MARK: View lifecycle
	/**
	Performs the following actions:
	- Sets the controller's first subview, if it is not set
	- Registers for notifications about keyboard appearance and keyboard frame changes
	*/
	override open func viewDidLoad() {
        super.viewDidLoad()
		
		// Set the caret color for all text fields of the controller's view
		if self.firstSubview == nil {
			self.firstSubview = self.view
		}
		
		// Register for keyboard appearance and frame change notifications
		NotificationCenter.default.addObserver(self, selector: #selector(TRIKTextInputVC.keyboardWillAppear(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(TRIKTextInputVC.keyboardFrameWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(TRIKTextInputVC.keyboardWillDisappear(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }

	// MARK: -
	// MARK: Instance methods
	/**
	Subject to the parameter recursive sets the tint color for all text fields in the entire subview hierarchy of a given view or sets the tint color for all text fields that are direct subviews of the given view.
	
	- parameters:
		- color: The tint color to set
		- view: The view whose text field subviews should be adjusted
		- recursive: Flag about whether or not the text field adjustment should be done recursively in view's subview hierarchy
	
	- returns: Total count of text fields
	*/
	public func setTintColor(_ color: UIColor, forTextFieldsInView view: UIView, recursive: Bool = false) -> Int {
		var count = 0
		
		if recursive {
			if let textField = view as? UITextField {
				textField.tintColor = color
				count += 1
			}
			else if view.subviews.count > 0 {
				for subview in view.subviews {
					count += setTintColor(color, forTextFieldsInView: subview, recursive: true)
				}
			}
		}
		else {
			if view.subviews.count > 0 {
				for subview in view.subviews {
					if let textField = subview as? UITextField {
						textField.tintColor = color
						count += 1
					}
				}
			}
		}
		
		return count
	}
	
	/**
	Creates a label sized subject to the parameters string and height.
	
	- parameters:
		- string: Text for the label
		- height: Height for the label's frame
		- font: Font to set for the label
		- textColor: Text color to set for the label
	
	- returns: Created label
	*/
	public func labelOfFlexibleWidth(withString string: String,
									 fixedHeight height: CGFloat,
									 font: UIFont = TRIKTextInputVC.defaultFont,
									 textColor color: UIColor = TRIKTextInputVC.defaultColor) -> UILabel {
		let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: TRIKTextInputVC.labelWidthMax, height: height))
		label.font = font
		label.textColor = color
		label.text = string
		label.sizeToFit()
		let originalFrame = CGRect(origin: label.frame.origin, size: CGSize(width: label.frame.size.width, height: height))
		let insets = UIEdgeInsetsMake(0.0, TRIKTextInputVC.labelInsetLeft, 0.0, 0.0)
		let paddedFrame = UIEdgeInsetsInsetRect(originalFrame, insets)
		label.frame = paddedFrame
		label.backgroundColor = TRIKConstant.Color.clear
		label.baselineAdjustment = UIBaselineAdjustment.alignCenters
		label.textAlignment = NSTextAlignment.center
		
		return label
	}
	
	/**
	Adds a border to the passed view.
	
	- parameters:
		- view: View that should get a border
		- color: Border color
	*/
	public func addBorder(withColor color: UIColor = TRIKConstant.Color.red,
						  andWidth width: CGFloat = TRIKTextInputVC.defaultBorderWidth,
						  toView view: UIView? = nil) {
		guard let borderView = view else {
			return
		}
		
		borderView.layer.borderColor = color.cgColor
		borderView.layer.borderWidth = width
		borderView.layer.masksToBounds = true
	}
	
	/**
	Removes a possible border from the passed view.
	
	- parameters:
		- view: View whose border should be removed
	*/
	public func removeBorder(fromView view: UIView) {
		guard view.layer.borderWidth != 0.0 else {
			return
		}
		
		view.layer.borderColor = TRIKTextInputVC.defaultBorderColor
		view.layer.borderWidth = 0.0
		view.layer.masksToBounds = true
	}

	// MARK: -
	// MARK: Interface changes
	override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		self.keyboardFrameWillChange(notification: nil)
	}

	// MARK: -
	// MARK: Memory management
	

}

// MARK: -
// MARK: Notifications and associated methods
extension TRIKTextInputVC {
	/**
	Calculates whether a keyboard appearance would hide the currently active text field of the controller's view and subject to the calculation result starts a view animation by triggering a method call of animationForKeyboard(withHeight:,referenceFrame:,direction:).
	
	- parameters:
		- notification: Notification.Name.UIKeyboardWillShow
	*/
	@objc private func keyboardWillAppear(notification: Notification) {
		// Guard notification contains info dict, and dict contains keyboard frame
		guard let infoDict = notification.userInfo, let keyboardFrame = infoDict[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
			return
		}
		
		self.keyboardAppearanceNotification = notification
		
		let convertedFrame = self.view.convert(keyboardFrame, from: self.view.window)
		let convertedHeight = convertedFrame.size.height
		
		// Guard active view is set
		guard let aView = self.activeView else {
			return
		}
		
		let convertedActiveViewOrigin = convertOrigin(ofView: aView, toView: self.firstSubview)
		let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0.0
		let padding = self.useActiveViewKeyboardPadding ? self.keyboardPadding : 0.0
		let keyboardWillOverlapActiveView = (self.firstSubview.frame.size.height - (convertedHeight - tabBarHeight)) < (convertedActiveViewOrigin.y + aView.frame.size.height + padding)
		if keyboardWillOverlapActiveView {
			self.viewAnimationActive = true
			self.keyboardHeight = convertedHeight
			self.referenceFrame = aView.frame
			self.animationForKeyboard(withHeight: self.keyboardHeight, referenceFrame: referenceFrame, direction: .up)
		}
	}
	
	/**
	If a view animation is currently active, triggers a method call of animationForKeyboard(withHeight:,referenceFrame:,direction:) on frame changes of the keyboard.
	
	- parameters:
		- notification: NSNotification.Name.UIKeyboardWillChangeFrame
	*/
	@objc private func keyboardFrameWillChange(notification: Notification?) {
		if var appearNotification = self.keyboardAppearanceNotification, var appearInfoDict = appearNotification.userInfo, let frameInfoDict = notification?.userInfo, let keyboardFrame = frameInfoDict[UIKeyboardFrameEndUserInfoKey] as? CGRect {
			appearInfoDict[UIKeyboardFrameEndUserInfoKey] = keyboardFrame
			appearNotification.userInfo = appearInfoDict
			self.keyboardAppearanceNotification = appearNotification
		}
		
		if self.viewAnimationActive {
			self.animationForKeyboard(withHeight: self.keyboardHeight, referenceFrame: self.referenceFrame, direction: .down)
			self.viewAnimationActive = false
		}
	}
	
	/**
	Sets the controller's flag for keyboard visibility to false.
	
	- parameters:
		- notification: Notification.Name.UIKeyboardWillHide
	*/
	@objc private func keyboardWillDisappear(notification: Notification) {
		self.keyboardAppearanceNotification = nil
	}
	
	/**
	Moves the controller's view subject to the parameter direction on appearance respectively frame changes of the keyboard. The distance of the movement is calculated using the parameter frame.
	
	- parameters:
		- height: The current height of the keyboard
		- frame: Frame of the currently active view
		- direction: Direction of the movement of the controller's view
	*/
	private func animationForKeyboard(withHeight height: CGFloat, referenceFrame frame: CGRect, direction: TRIKTextInputVC.AnimationDirection) {
		// Guard active view is set
		guard let aView = self.activeView else {
			return
		}
		
		let convertedActiveViewOrigin = convertOrigin(ofView: aView, toView: self.firstSubview)
		let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0.0
		var distance = fabs(self.firstSubview.frame.size.height - (convertedActiveViewOrigin.y + aView.frame.size.height) - height) - tabBarHeight
		
		if self.useActiveViewKeyboardPadding {
			let keyboardWouldNotOverlapActiveViewWithoutPadding = (self.firstSubview.frame.size.height - (height - tabBarHeight)) >= (convertedActiveViewOrigin.y + aView.frame.size.height)
			if keyboardWouldNotOverlapActiveViewWithoutPadding {
				distance = fabs(self.keyboardPadding) - distance
			}
			else {
				distance += fabs(self.keyboardPadding)
			}
			
			if direction == .up {
				var adjustmentNecessary = false
				// Prevent active view from being moved off screen
				let activeViewWouldMoveOffScreen = convertedActiveViewOrigin.y - distance < self.view.frame.origin.y
				if activeViewWouldMoveOffScreen {
					adjustmentNecessary = true
					distance = convertedActiveViewOrigin.y - self.firstSubview.frame.origin.y
				}
				// Prevent controller's view from being moved higher than keyboard height
				let rootViewWouldMoveHigherThanKeyboard = distance > height
				if rootViewWouldMoveHigherThanKeyboard {
					adjustmentNecessary = true
					distance = height
				}
				// Store reference to adjusted distance for reverting animation later
				if adjustmentNecessary {
					self.adjustedDistance = distance
				}
			}
			else if let adjustedDistance = self.adjustedDistance  {
				distance = adjustedDistance
				self.adjustedDistance = nil
			}
		}
		
		let movement = direction == .up ? -distance : distance
		
		UIView.animate(withDuration: TRIKConstant.AnimationTime.medium, animations: {
			self.view.frame = self.view.frame.offsetBy(dx: 0.0, dy: movement)
		})
		
	}
	
	
	/**
	Converts the origin of a source view through its entire superview hierarchy to a given destination view.
	
	Discussion
	-
	destView must reside somewhere in the direct superview hierarchy of srcView.
	
	- parameters:
		- srcView: Source view whose origin should be converted
		- destView: Destination view to whose coordinate system the source view's origin should be converted
	
	- returns: Converted origin
	*/
	private func convertOrigin(ofView srcView: UIView, toView destView: UIView) -> CGPoint {
		var convertedOrigin = srcView.bounds.origin
		var superview: UIView? = srcView.superview
		var newSrcView: UIView = srcView
		while superview != nil && superview != destView {
			convertedOrigin = newSrcView.convert(convertedOrigin, to: superview)
			newSrcView = superview!
			superview = superview!.superview
		}
		
		return newSrcView.convert(convertedOrigin, to: destView)
	}
}

// MARK: -
// MARK: Textfield delegate protocol conformance
extension TRIKTextInputVC: UITextFieldDelegate {
	/**
	Sets textField as the controller's active view.
	
	- parameters:
		- textField: Text field triggering the method call
	*/
	open func textFieldDidBeginEditing(_ textField: UITextField) {
		self.activeView = textField
		
		if let notification = self.keyboardAppearanceNotification {
			NotificationCenter.default.post(notification)
		}
	}
	
	/**
	If a view animation is currently active, reverts that animation, and resets the controller's active view.
	
	- parameters:
		- textField: Text field triggering the method call
	*/
	open func textFieldDidEndEditing(_ textField: UITextField) {
		if self.viewAnimationActive {
			self.animationForKeyboard(withHeight: self.keyboardHeight, referenceFrame: self.referenceFrame, direction: .down)
			self.viewAnimationActive = false
		}
		self.activeView = nil
	}
}
