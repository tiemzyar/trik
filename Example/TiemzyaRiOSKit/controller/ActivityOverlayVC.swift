//
//  ActivityOverlayVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 12.10.18.
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
Controller for showing the usage of an activity overlay.
*/
class ActivityOverlayVC: OverlayVC {
	// MARK: Nested types
	/**
	Enumeration of possible activity styles for the overlay.
	*/
	enum ActivityStyle: Int {
		case indicator = 0
		case progress
	}

	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Description label for the overlay's activity style
	@IBOutlet weak var activityStyleLabel: UILabel!
	
	/// Control for customizing the overlay's activity style
	@IBOutlet weak var activityStyleControl: UISegmentedControl!
	
	/// Description label for the overlay's progress
	@IBOutlet weak var progressSliderLabel: UILabel!
	
	/// Slider for customizing the overlay's progress
	@IBOutlet weak var progressSlider: UISlider!
	
	/// Description label for the overlay's use-button option
	@IBOutlet weak var useButtonLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's use-button option
	@IBOutlet weak var useButtonSwitch: UISwitch!
	
	/// Stores the selected activity style for the overlay
	var selectedActivity: ActivityOverlayVC.ActivityStyle = .indicator
	
	/// Stores the state of the overlay's use-button option
	var useButton: Bool = false

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.exampleDescriptionLabel.text = localizedString(for: "ActOverlayVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
		self.activityStyleLabel.text = localizedString(for: "ActOverlayVC: Label Activity Style", fallback: TRIKConstant.Language.Code.german)
		self.progressSliderLabel.text = localizedString(for: "ActOverlayVC: Label Progress Slider", fallback: TRIKConstant.Language.Code.german)
		self.useButtonLabel.text = localizedString(for: "ActOverlayVC: Label Use Button", fallback: TRIKConstant.Language.Code.german)
		
		if let style = ActivityOverlayVC.ActivityStyle.init(rawValue: self.activityStyleControl.selectedSegmentIndex) {
			self.selectedActivity = style
		}
		self.useButton = self.useButtonSwitch.isOn;
    }

	// MARK: -
	// MARK: Instance methods
	@IBAction override func colorStyleDidChange(_ sender: UISegmentedControl) {
		super.colorStyleDidChange(sender)
		
		self.dismissOverlay(recreate: true)
	}
	
	@IBAction override func positionDidChange(_ sender: UISegmentedControl) {
		super.positionDidChange(sender)
		
		self.dismissOverlay(recreate: true)
	}
	
	/**
	Reacts to changes of the overlay's activity style.
	
	- parameters:
		- sender: The control triggering the method call
	*/
	@IBAction func activityStyleDidChange(_ sender: UISegmentedControl) {
		if let style = ActivityOverlayVC.ActivityStyle.init(rawValue: sender.selectedSegmentIndex) {
			self.selectedActivity = style
		}
		
		switch self.selectedActivity {
		case .indicator:
			self.progressSliderLabel.isHidden = true
			self.progressSlider.isHidden = true
			if let overlay = self.overlay as? TRIKActivityOverlay {
				overlay.presentActivityIndicator()
			}
		case .progress:
			self.progressSliderLabel.isHidden = false
			self.progressSlider.isHidden = false
			if let overlay = self.overlay as? TRIKActivityOverlay {
				overlay.presentProgressBar()
				overlay.updateProgress(self.progressSlider.value)
			}
		}
		
		self.dismissOverlay(recreate: true)
	}
	
	/**
	Reacts to changes of the overlay's progress.
	
	- parameters:
		- sender: The slider triggering the method call
	*/
	@IBAction func progressDidChange(_ sender: UISlider) {
		if let overlay = self.overlay as? TRIKActivityOverlay {
			overlay.updateProgress(sender.value)
		}
	}
	
	/**
	Reacts to changes of the overlay's use-button option state.
	
	- parameters:
		- sender: The switch triggering the method call
	*/
	@IBAction func useButtonStateDidChange(_ sender: UISwitch) {
		self.useButton = sender.isOn
		
		if let overlay = self.overlay as? TRIKActivityOverlay {
			if self.useButton {
				overlay.setButtonTitle("Tap me!")
				overlay.presentButton()
			}
			else {
				overlay.dismissButton()
			}
		}
	}
	
	override func createOverlay() {
		super.createOverlay()
		
		self.overlay = TRIKActivityOverlay(superview: self.firstSubview,
										   text: "This is a test\nwith more\nthan one line!",
										   font: UIFont.systemFont(ofSize: 20.0),
										   style: self.selectedStyle,
										   position: self.position,
										   activityColor: TRIKConstant.Color.Blue.light)
		
		let overlay = self.overlay as! TRIKActivityOverlay
		
		switch self.selectedActivity {
		case .indicator:
			overlay.presentWithActivityIndicator()
		case .progress:
			overlay.presentWithProgressBar()
			overlay.updateProgress(self.progressSlider.value)
		}
		
		if self.useButton {
			overlay.setButtonTitle("Dismiss")
			overlay.addButtonTarget(self, action: #selector(dismissButtonTapped(_:)))
			overlay.presentButton()
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
