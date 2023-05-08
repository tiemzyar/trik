//
//  BigTouchZoneSliderVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 04.12.18.
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
Controller for showing the usage of a big touch zone slider.
*/
class BigTouchZoneSliderVC: ExampleVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Scroll view containing all controls for customizing the slider
	@IBOutlet weak var controlsSV: UIScrollView!
	
	/// Description label for the slider's style.
	@IBOutlet weak var sliderStyleLabel: UILabel!
	
	/// Control for customizing the slider's style
	@IBOutlet weak var sliderStyleControl: UISegmentedControl!
	
	/// Label for showing an info that only digits are allowed in the text fields of the controller's view
	@IBOutlet weak var digitsOnlyLabel: UILabel!
	
	/// Description label for the slider's minimum value
	@IBOutlet weak var minValLabel: UILabel!
	
	/// Text field for customizing the slider's minimum value
	@IBOutlet weak var minValTF: UITextField!
	
	/// Description label for the slider's maximum value
	@IBOutlet weak var maxValLabel: UILabel!
	
	/// Text field for customizing the slider's maximum value
	@IBOutlet weak var maxValTF: UITextField!
	
	/// Description label for the slider's initial value
	@IBOutlet weak var initialValLabel: UILabel!
	
	/// Text field for customizing the slider's initial value
	@IBOutlet weak var initialValTF: UITextField!
	
	/// Description label for the slider's interval
	@IBOutlet weak var intervalLabel: UILabel!
	
	/// Text field for customizing the slider's interval
	@IBOutlet weak var intervalTF: UITextField!
	
	/// Description label for the storyboard-created slider
	@IBOutlet weak var sliderIBLabel: UILabel!
	
	/// Displays the storyboard-created slider's current value
	@IBOutlet weak var sliderIBValueLabel: UILabel!
	
	/// References the storyboard-created slider
	@IBOutlet weak var sliderIB: TRIKBigTouchZoneSlider!
	
	/// Description label for the code-created slider
	@IBOutlet weak var sliderCodeLabel: UILabel!
	
	/// Displays the code-created slider's current value
	@IBOutlet weak var sliderCodeValueLabel: UILabel!
	
	/// View to which the code-created slider show be aligned
	@IBOutlet weak var sliderCodeAlignmentView: UIView!
	
	/// References the code-created slider
	var sliderCode: TRIKBigTouchZoneSlider?
	
	/// Button for triggering the code-created slider's dismissal
	@IBOutlet weak var dismissButton: UIButton!
	
	/// Button for triggering the code-created slider's presentation
	@IBOutlet weak var presentButton: UIButton!
	
	/// Stores the selected style of the slider
	var selectedStyle: TRIKBigTouchZoneSlider.Style = .grey
	
	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example stup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.useActiveViewKeyboardPadding = true
		self.keyboardPadding = 100.0
		
		self.exampleDescriptionLabel.text = localizedString(forKey: "BTZSliderVC: Label Example Desc",
															fallback: Locale.appFallbackLanguage)
		self.sliderStyleLabel.text = localizedString(forKey: "BTZSliderVC: Label Slider Style",
													 fallback: Locale.appFallbackLanguage)
		self.digitsOnlyLabel.text = localizedString(forKey: "BTZSliderVC: Label Digits Only",
													fallback: Locale.appFallbackLanguage)
		self.minValLabel.text = localizedString(forKey: "BTZSliderVC: Label Min Value",
												fallback: Locale.appFallbackLanguage)
		self.maxValLabel.text = localizedString(forKey: "BTZSliderVC: Label Max Value",
												fallback: Locale.appFallbackLanguage)
		self.initialValLabel.text = localizedString(forKey: "BTZSliderVC: Label Initial Value",
													fallback: Locale.appFallbackLanguage)
		self.intervalLabel.text = localizedString(forKey: "BTZSliderVC: Label Interval",
												  fallback: Locale.appFallbackLanguage)
		self.sliderIBLabel.text = localizedString(forKey: "BTZSliderVC: Label Slider IB",
												  fallback: Locale.appFallbackLanguage)
		self.sliderCodeLabel.text = localizedString(forKey: "BTZSliderVC: Label Slider Code",
													fallback: Locale.appFallbackLanguage)
		self.dismissButton.setTitle(localizedString(forKey: "BTZSliderVC: Button Dismiss",
													fallback: Locale.appFallbackLanguage),
									for: .normal)
		self.presentButton.setTitle(localizedString(forKey: "BTZSliderVC: Button Present",
													fallback: Locale.appFallbackLanguage),
									for: .normal)
		
		self.sliderCodeValueLabel.text = nil
		self.determineStyle()
		self.updateSliderIB()
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Determines the style to use for the slider.
	*/
	func determineStyle() {
		switch self.sliderStyleControl.selectedSegmentIndex {
		case TRIKBigTouchZoneSlider.Style.grey.rawValue:
			self.selectedStyle = .grey
		case TRIKBigTouchZoneSlider.Style.blue.rawValue:
			self.selectedStyle = .blue
		case TRIKBigTouchZoneSlider.Style.black.rawValue:
			self.selectedStyle = .black
		default:
			self.selectedStyle = .blue
		}
	}
	
	/**
	Converts a text field's text to a float value, if possible.
	
	- parameters:
		- textField: Text field whose text to convert
	
	- returns: The converted value or 0.0
	*/
	func convertValue(ofTextField textField: UITextField) -> Float {
		var convertedValue: Float = 0.0
		if let text = textField.text, let value = Float(text) {
			convertedValue = value
		}
		
		return convertedValue
	}
	
	/**
	Reacts to changes of the slider's style.
	
	- parameters:
		- sender: The control triggering the method call
	*/
	@IBAction func sliderStyleDidChange(_ sender: UISegmentedControl) {
		self.determineStyle()
		
		self.updateSliderIB()
		self.dismissSlider(recreate: true)
	}
	
	/**
	Triggers the creation of the slider.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func createButtonTapped(_ sender: UIButton) {
		if self.sliderCode != nil {
			self.dismissSlider(recreate: true)
		}
		else {
			self.createSlider()
		}
	}
	
	/**
	Triggers the dismissal of the code-created slider.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func dismissButtonTapped(_ sender: UIButton) {
		self.dismissSlider()
	}
	
	/**
	Creates the slider.
	*/
	func createSlider() {
		let initVal = self.convertValue(ofTextField: self.initialValTF)
		self.sliderCode = TRIKBigTouchZoneSlider(superview: self.firstSubview,
												 alignmentView: self.sliderCodeAlignmentView,
												 style: self.selectedStyle,
												 minValue: self.convertValue(ofTextField: self.minValTF),
												 maxValue: self.convertValue(ofTextField: self.maxValTF),
												 initialValue: initVal,
												 interval: self.convertValue(ofTextField: self.intervalTF),
												 delegate: self)
		
		self.sliderCodeValueLabel.text = "\(initVal)"
	}
	
	/**
	Dismisses and optionally recreates the code-created slider.
	
	- parameters:
		- recreate: Flag about whether or not to recreate the slider after its dismissal.
	*/
	func dismissSlider(recreate: Bool = false) {
		if self.sliderCode?.superview != nil {
			self.sliderCode?.removeFromSuperview()
			self.sliderCode = nil
			self.sliderCodeValueLabel.text = nil
			if recreate {
				self.createSlider()
			}
		}
	}
	
	/**
	Updates the storyboard-created slider.
	*/
	func updateSliderIB() {
		let initVal = self.convertValue(ofTextField: self.initialValTF)
		self.sliderIB.delegate = self
		self.sliderIB.setStyle(self.selectedStyle,
							   minValue: self.convertValue(ofTextField: self.minValTF),
							   maxValue: self.convertValue(ofTextField: self.maxValTF),
							   initialValue: initVal,
							   interval: self.convertValue(ofTextField: self.intervalTF))
		
		self.sliderIBValueLabel.text = "\(initVal)"
	}
	
	// MARK: -
	// MARK: Navigation
	

	// MARK: -
	// MARK: Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: -
// MARK: Big touch zone slider delegate conformance
extension BigTouchZoneSliderVC: TRIKBigTouchZoneSliderDelegate {
	func slider(_ slider: TRIKBigTouchZoneSlider, didChangeValueTo value: Float) {
		if slider == self.sliderIB {
			self.sliderIBValueLabel.text = "\(value)"
		}
		else if slider == self.sliderCode {
			self.sliderCodeValueLabel.text = "\(value)"
		}
	}
}

// MARK: -
// MARK: Text field delegate conformance
extension BigTouchZoneSliderVC {
	override func textFieldDidEndEditing(_ textField: UITextField) {
		super.textFieldDidEndEditing(textField)
		
		if let text = textField.text, !text.isEmpty {
			self.updateSliderIB()
			self.dismissSlider(recreate: true)
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if textField == self.minValTF {
			self.maxValTF.becomeFirstResponder()
		}
		else if textField == self.maxValTF {
			self.initialValTF.becomeFirstResponder()
		}
		else if textField == self.initialValTF {
			self.intervalTF.becomeFirstResponder()
		}
		
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if string.isEmpty {
			return true
		}
		
		let lcString = string.lowercased()
		let digitsSet = CharacterSet(charactersIn: "0123456789.-+")
		if lcString.rangeOfCharacter(from: digitsSet) != nil {
			self.digitsOnlyLabel.isHidden = true
			return true
		}
		else {
			self.digitsOnlyLabel.isHidden = false
			return false
		}
	}
}
