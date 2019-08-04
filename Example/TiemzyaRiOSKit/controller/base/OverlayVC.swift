//
//  OverlayVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 15.11.18.
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
import TiemzyaRiOSKit

// MARK: -
// MARK: Implementation
/**
Parent controller for all overlay examples.
*/
class OverlayVC: ExampleVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Scroll view containing all controls for customizing an overlay
	@IBOutlet weak var controlsSV: UIScrollView!
	
	/// Description label for an overlay's style
	@IBOutlet weak var colorStyleLabel: UILabel!
	
	/// Control for customizing an overlay's style
	@IBOutlet weak var colorStyleControl: UISegmentedControl!
	
	/// Description label for an overlay's position
	@IBOutlet weak var positionLabel: UILabel!
	
	/// Control for customizing an overlay's position
	@IBOutlet weak var positionControl: UISegmentedControl!
	
	/// Button for triggering an overlay's dismissal
	@IBOutlet weak var dismissOverlayButton: UIButton!
	
	/// Button for triggering an overlay's presentation
	@IBOutlet weak var presentOverlayButton: UIButton!
	
	/// References the overlay to display in the controller's view
	var overlay: TRIKOverlay?
	
	/// Stores the selected style for an overlay
	var selectedStyle: TRIKOverlay.Style = .white
	
	/// Stores the selected position for an overlay
	var position: TRIKOverlay.Position = .top

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.colorStyleLabel.text = localizedString(for: "OverlayVC: Label Color Style", fallback: TRIKConstant.Language.Code.german)
		self.positionLabel.text = localizedString(for: "OverlayVC: Label Position", fallback: TRIKConstant.Language.Code.german)
		self.dismissOverlayButton?.setTitle(localizedString(for: "OverlayVC: Button Dismiss",
														   fallback: TRIKConstant.Language.Code.german),
										   for: .normal)
		self.presentOverlayButton?.setTitle(localizedString(for: "OverlayVC: Button Present",
														   fallback: TRIKConstant.Language.Code.german),
										   for: .normal)
		
		self.determineStyle()
		self.determinePosition()
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Determines the style to use for an overlay.
	*/
	func determineStyle() {
		switch self.colorStyleControl.selectedSegmentIndex {
		case TRIKOverlay.Style.white.rawValue:
			self.selectedStyle = .white
		case TRIKOverlay.Style.light.rawValue:
			self.selectedStyle = .light
		case TRIKOverlay.Style.dark.rawValue:
			self.selectedStyle = .dark
		case TRIKOverlay.Style.black.rawValue:
			self.selectedStyle = .black
		case TRIKOverlay.Style.tiemzyar.rawValue:
			self.selectedStyle = .tiemzyar
		default:
			self.selectedStyle = .white
		}
	}
	
	/**
	Determines the position to use for an overlay.
	*/
	func determinePosition() {
		switch self.positionControl.selectedSegmentIndex {
		case TRIKOverlay.Position.top.rawValue:
			self.position = .top
		case TRIKOverlay.Position.center.rawValue:
			self.position = .center
		case TRIKOverlay.Position.bottom.rawValue:
			self.position = .bottom
		case TRIKOverlay.Position.full.rawValue:
			self.position = .full
		default:
			self.position = .top
		}
	}
	
	/**
	Reacts to overlay style changes.
	
	- parameters:
		- sender: The control triggering the method call
	*/
	@IBAction func colorStyleDidChange(_ sender: UISegmentedControl) {
		self.determineStyle()
	}
	
	/**
	Reacts to overlay position changes.
	
	- parameters:
		- sender: The control triggering the method call
	*/
	@IBAction func positionDidChange(_ sender: UISegmentedControl) {
		self.determinePosition()
	}
	
	/**
	Triggers the creation of an overlay.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func createButtonTapped(_ sender: UIButton) {
		if self.overlay != nil {
			self.dismissOverlay(recreate: true)
		}
		else {
			self.createOverlay()
		}
	}
	
	/**
	Triggers the dismissal of an overlay.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func dismissButtonTapped(_ sender: UIButton) {
		self.dismissOverlay()
	}
	
	/**
	Creates an overlay.
	*/
	func createOverlay() {}
	
	/**
	Dismisses and optionally recreates an overlay.
	
	- parameters:
		- recreate: Flag about whether or not to recreate an overlay after its dismissal.
	*/
	func dismissOverlay(recreate: Bool = false) {
		self.overlay?.dismiss(animated: true) {(_) in
			self.overlay?.destroy()
			self.overlay = nil
			if recreate {
				self.createOverlay()
			}
		}
	}

	// MARK: -
	// MARK: Navigation
    

	// MARK: -
	// MARK: Interface changes
	

	// MARK: -
	// MARK: Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
