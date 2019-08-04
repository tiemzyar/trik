//
//  KeyboardAnimationVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 11.12.18.
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
Controller for showing the usage of the TRIK framework's view-animation-on-keyboard-events feature implemented in TRIKTextInputVC.

Usage:
Make your controller inherit from the framework's controller and your active text fields will never be hidden by the system keyboard.
You just have to make sure to always call the super class method first, if you want to use the text field delegate methods
- textFieldDidBeginEditing(_ textField: UITextField) or
- textFieldDidEndEditing(_ textField: UITextField)
*/
class KeyboardAnimationVC: ExampleVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Simple counter
	var counter: Int = 0
	
	/// Slider for selecting the padding to use in keyboard animations
	@IBOutlet weak var paddingSlider: TRIKBigTouchZoneSlider!
	
	/// Description label for the controller's padding slider
	@IBOutlet weak var paddingSliderLabel: UILabel!
	
	/// Displays the currently selected keyboard padding
	@IBOutlet weak var paddingSliderValueLabel: UILabel!
	
	/// Stores references to all text fields in the subview hierarchy of the controller's view
	var textFields: [UITextField] = []

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.exampleDescriptionLabel.text = localizedString(for: "KAnimVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
		
		self.referenceTextFields(inView: self.view, resetExistingReferences: true)
		
		let initVal: Float = 100.0
		self.paddingSlider.setStyle(.blue,
									minValue: 0.0,
									maxValue: 150.0,
									initialValue: initVal,
									interval: 1.0)
		
		// Set this flag to be able to set a padding between the keyboard an the currently active view.
		self.useActiveViewKeyboardPadding = true
		self.updatePadding(to: initVal)
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Recursively retrieves references to all text fields in the subview hierarchy of a passed view and stores them in the controller's textFields array.
	
	- parameters:
		- view: View whose subview hierarchy should be searched for text fields
		- reset: Flag about whether or not to reset the controller's textFields array before starting the search
	*/
	func referenceTextFields(inView view: UIView, resetExistingReferences reset: Bool = false) {
		if reset {
			self.textFields.removeAll()
		}
		
		for subview in view.subviews {
			if let textField = subview as? UITextField {
				self.textFields.append(textField)
			}
			else {
				self.referenceTextFields(inView: subview)
			}
		}
	}
	
	/**
	Reacts to changes of the controller's padding slider.
	
	- parameters:
		- sender: The slider triggering the method call
	*/
	@IBAction func sliderValueDidChange(_ sender: UISlider) {
		/*
		Important:
		Never change the keyboard padding while the controller's view has been moved up due to the keyboard's appearance!
		If you do, you will mess up the layout of the controller's view.
		Ideally, you would set the padding once during viewDidLoad(), and then do not touch it again. But if you have to change it for some reason, be sure to make the controller's active view resign as first responder first (as seen below).
		*/
		if let aView = self.activeView {
			aView.resignFirstResponder()
		}
		self.updatePadding(to: sender.value)
	}
	
	func updatePadding(to value: Float) {
		self.paddingSliderValueLabel.text = "\(value)"
		self.keyboardPadding = CGFloat(value)
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

extension KeyboardAnimationVC {
	/*
	Makes a random text field from the controller's textFields array become first responder or just makes the currently active text field resign as first responder (subject to the controller's counter).
	*/
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if counter < 5 {
			counter += 1
			let randomIndex = Int(arc4random() % UInt32(self.textFields.count))
			let randomTF = self.textFields[randomIndex]
			randomTF.becomeFirstResponder()
		}
		else {
			counter = 0
		}
		
		return true
	}
}

