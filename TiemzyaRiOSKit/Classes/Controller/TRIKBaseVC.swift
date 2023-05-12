//
//  TRIKBaseVC.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 05.10.18.
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
View controller that can be used as base view controller for all view controllers in an application that make use of a toolbar and backwards navigation functionality.
*/
open class TRIKBaseVC: UIViewController {
	// MARK: Type properties
	private static let buttonSideLength: CGFloat = 30.0

	// MARK: -
	// MARK: Instance properties
	/// Toolbar of the controller's view
	@IBOutlet public weak var baseToolbar: UIToolbar!
	
	/// Flag about whether or not the controller's view appeared for the first time
	public var firstAppearance: Bool = true
	
	/// First subview of the controller's view containing all other UI elements
	@IBOutlet public weak var firstSubview: UIView!
	
	/// Bar button for backwards navigation (within the controller's toolbar)
	public var previousViewBarButton: UIBarButtonItem?
	
	/// Button for backwards navigation
	@IBOutlet public weak var previousViewButton: UIButton!
	
	/// Stores the title for the title label of the controller's view (necessary for setting the controller's title in prepareForSegue(segue:sender:)
	public var titleLabelText: String?
	
	/// Title of the controller's view
	@IBOutlet public weak var titleLabel: UILabel!
	

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs the following actions:
	- Starts monitoring network reachability
	- Sets automaticallyAdjustsScrollViewInsets to false (to prevent layout problems with scroll view subviews)
	*/
	override open func viewDidLoad() {
        super.viewDidLoad()
		
		// Make sure the controller's first subview is always set
		if self.firstSubview == nil {
			self.firstSubview = self.view
		}
		
		self.titleLabel.text = self.titleLabelText
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Navigates one view back in the navigation hierarchy by making the controller's navigation controller pop the topmost view controller on its stack.
	
	- parameters:
		- sender: UI element triggering the method call
	*/
	@IBAction open func returnToPreviousView(sender: Any?) {
		if let navVC = self.navigationController {
			navVC.popViewController(animated: false)
		}
	}
	
	/**
	Creates a toolbar button that triggers a method call of returnToPreviousView(sender:) and adds it to the controller's toolbar.
	
	- parameters:
		- image: The image to display within the toolbar button
	*/
	public func createToolbarBackButton(withImage image: UIImage? = nil) {
		guard self.baseToolbar != nil else {
			return
		}
		
		var buttons: [UIBarButtonItem] = []
		if let items = self.baseToolbar.items {
			buttons = items
		}
		
		var buttonImage = image
		if buttonImage == nil {
			if let imagePath = TRIKUtil.trikResourceBundle()?.path(forResource: "TRIKButtonBack", ofType: TRIKConstant.FileManagement.FileExtension.png) {
				buttonImage = UIImage(contentsOfFile: imagePath)
			}
		}
		
		let button = UIButton(type: UIButton.ButtonType.custom)
		self.previousViewButton = button
		self.previousViewButton.setImage(buttonImage, for: UIControl.State.normal)
		self.previousViewButton.addConstraint(NSLayoutConstraint(item: self.previousViewButton!,
		                                                         attribute: NSLayoutConstraint.Attribute.height,
		                                                         relatedBy: NSLayoutConstraint.Relation.equal,
		                                                         toItem: nil,
		                                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
		                                                         multiplier: 1.0,
		                                                         constant: TRIKBaseVC.buttonSideLength))
		self.previousViewButton.addConstraint(NSLayoutConstraint(item: self.previousViewButton!,
		                                                         attribute: NSLayoutConstraint.Attribute.width,
		                                                         relatedBy: NSLayoutConstraint.Relation.equal,
		                                                         toItem: nil,
		                                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
		                                                         multiplier: 1.0,
		                                                         constant: TRIKBaseVC.buttonSideLength))
		self.previousViewButton.addTarget(self, action: #selector(returnToPreviousView(sender:)), for: UIControl.Event.touchUpInside)
		self.previousViewBarButton = UIBarButtonItem(customView: self.previousViewButton)
		
		buttons.insert(self.previousViewBarButton!, at: 0)
		self.baseToolbar.setItems(buttons, animated: false)
	}

	// MARK: -
	// MARK: Navigation


	// MARK: -
	// MARK: Interface changes
	/**
	Performs adaptions of the controller to size transitions.
	
	Discussion
	-
	This method's implementation is empty. The actual functionality for adapting the controller to a new size must be implemented in the controller's subclasses.
	
	- parameters:
		- size: Size for which to adapt the controller
		- coordinator: Size transition coordinator
	*/
	open func adaptUI(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {}

	/**
	Performs adaptions of the controller to device orientation changes.
	
	Discussion
	-
	This method's implementation is empty. The actual functionality for adapting the controller to a new orientation must be implemented in the controller's subclasses.
	
	- parameters:
		- orientation: Device orientation for which to adapt the controller
	*/
	open func adaptUI(toDeviceOrientation orientation: UIDeviceOrientation) {}
	
	/**
	Performs adaptions of the controller to interface orientation changes.
	
	Discussion
	-
	This method's implementation is empty. The actual functionality for adapting the controller to a new orientation must be implemented in the controller's subclasses.
	
	- parameters:
		- orientation: Interface orientation for which to adapt the controller
	*/
	open func adaptUI(toInterfaceOrientation orientation: UIInterfaceOrientation) {}

	// MARK: -
	// MARK: Memory management
	

}
