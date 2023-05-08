//
//  AutoDestroyOverlayVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 16.10.18.
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
Controller for showing the usage of an auto destroy overlay.
*/
class AutoDestroyOverlayVC: OverlayVC {
	// MARK: Nested types
	

	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Description label for the overlay's destruction delay
	@IBOutlet weak var destructionDelayDescLabel: UILabel!
	
	/// Slider for customizing the overlay's destruction delay
	@IBOutlet weak var destructionDelaySlider: UISlider!
	
	/// Displays the currently selected destruction delay
	@IBOutlet weak var destructionDelayValueLabel: UILabel!
	
	/// Description label for the overlay's tap-to-destroy option
	@IBOutlet weak var tapToDestroyLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's tap-to-destroy option
	@IBOutlet weak var tapToDestroySwitch: UISwitch!
	
	/// Button for triggering the overlay's presentation
	@IBOutlet weak var addOverlayButton: UIButton!

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.exampleDescriptionLabel.text = localizedString(forKey: "ADOverlayVC: Label Example Desc",
															fallback: Locale.appFallbackLanguage)
		self.destructionDelayDescLabel.text = localizedString(forKey: "ADOverlayVC: Label Destruction Delay",
															  fallback: Locale.appFallbackLanguage)
		self.tapToDestroyLabel.text = localizedString(forKey: "ADOverlayVC: Label Tap To Destroy",
													  fallback: Locale.appFallbackLanguage)
		self.addOverlayButton.setTitle(localizedString(forKey: "ADOverlayVC: Button Add Overlay",
													   fallback: Locale.appFallbackLanguage),
									   for: .normal)
		
		self.determineDestructionDelay()
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Determines the destruction delay to use for the overlay.
	*/
	func determineDestructionDelay() {
		self.destructionDelayValueLabel.text = "\(String(format:"%.1f", self.destructionDelaySlider.value))"
	}
	
	/**
	Reacts to changes of the overlay's destruction delay.
	
	- parameters:
		- sender: The slider triggering the method call
	*/
	@IBAction func destructionDelayDidChange(_ sender: UISlider) {
		self.determineDestructionDelay()
	}
	
	/**
	Creates the overlay.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func createADOverlay(_ sender: UIButton) {
		self.overlay = TRIKAutoDestroyOverlay(superview: self.firstSubview,
											  text: "Some Info 4 U",
											  font: UIFont.systemFont(ofSize: 20.0),
											  style: self.selectedStyle,
											  position: self.position,
											  destroyAfter: Double(self.destructionDelaySlider.value),
											  tapToDestroy: self.tapToDestroySwitch.isOn)
		
		self.overlay?.present(animated: true)
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
