//
//  CountrySelectionVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 17.10.18.
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
Controller for showing the usage of a country overlay.
*/
class CountryOverlayVC: OverlayVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Description label for the numeric code of a selected country
	@IBOutlet weak var countryCodeNumDescLabel: UILabel!
	
	/// Displays the numeric code of a selected country
	@IBOutlet weak var countryCodeNumLabel: UILabel!
	
	/// Description label for the alpha-2 code of a selected country
	@IBOutlet weak var countryCode2DescLabel: UILabel!
	
	/// Displays the alpha-2 code of a selected country
	@IBOutlet weak var countryCode2Label: UILabel!
	
	/// Description label for the alpha-3 code of a selected country
	@IBOutlet weak var countryCode3DescLabel: UILabel!
	
	/// Displays the alpha-3 code of a selected country
	@IBOutlet weak var countryCode3Label: UILabel!
	
	/// Description label for the name of a selected country
	@IBOutlet weak var countryNameDescLabel: UILabel!
	
	/// Displays the name of a selected country
	@IBOutlet weak var countryNameLabel: UILabel!
	
	/// Description label for the overlay's localization-enabled option
	@IBOutlet weak var localizationEnabledLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's localization-enabled option
	@IBOutlet weak var localizationSwitch: UISwitch!
	
	/// Heading for the selected-country section of the controller's view
	@IBOutlet weak var selectedCountryLabel: UILabel!
	
	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.exampleDescriptionLabel.text = localizedString(forKey: "COverlayVC: Label Example Desc",
															fallback: Locale.appFallbackLanguage)
		self.countryCodeNumDescLabel.text = localizedString(forKey: "COverlayVC: Label Country Code Num Desc",
															fallback: Locale.appFallbackLanguage)
		self.countryCode2DescLabel.text = localizedString(forKey: "COverlayVC: Label Country Code 2 Desc",
														  fallback: Locale.appFallbackLanguage)
		self.countryCode3DescLabel.text = localizedString(forKey: "COverlayVC: Label Country Code 3 Desc",
														  fallback: Locale.appFallbackLanguage)
		self.countryNameDescLabel.text = localizedString(forKey: "COverlayVC: Label Country Name Desc",
														 fallback: Locale.appFallbackLanguage)
		self.localizationEnabledLabel.text = localizedString(forKey: "COverlayVC: Label Localization Enabled",
															 fallback: Locale.appFallbackLanguage)
		self.selectedCountryLabel.text = localizedString(forKey: "COverlayVC: Label Selected Country",
														 fallback: Locale.appFallbackLanguage)
		
		self.useActiveViewKeyboardPadding = true
		self.keyboardPadding = 100.0
		
		self.countryCode2Label.text = TRIKConstant.SpecialString.empty
		self.countryCode3Label.text = TRIKConstant.SpecialString.empty
		self.countryCodeNumLabel.text = TRIKConstant.SpecialString.empty
		self.countryNameLabel.text = TRIKConstant.SpecialString.empty
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
	Reacts to changes of the overlay's localization-enabled option state.
	
	- parameters:
		- sender: The switch triggering the method call
	*/
	@IBAction func localizationEnabledDidChange(_ sender: UISwitch) {
		self.dismissOverlay(recreate: true)
	}
	
	override func createOverlay() {
		super.createOverlay()
		
		self.overlay = TRIKCountryOverlay(superview: self.firstSubview,
										  headerFont: UIFont.boldSystemFont(ofSize: 15.0),
										  contentFont: UIFont.systemFont(ofSize: 12.0),
										  style: self.selectedStyle,
										  position: self.position,
										  locale: .german,
										  localizationEnabled: self.localizationSwitch.isOn,
										  delegate: self)
		
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

// MARK: -
// MARK: Country overlay delegate conformance
extension CountryOverlayVC: TRIKCountryOverlayDelegate {
	func countryOverlay(_ overlay: TRIKCountryOverlay,
						didSelectCountry country: (names: [String : String], codeA2: String, codeA3: String, codeNum: String)) {
		let localizedKey = overlay.localizedCountryNameKey()
		self.countryNameLabel.text = country.names[localizedKey]
		self.countryCode2Label.text = country.codeA2
		self.countryCode3Label.text = country.codeA3
		self.countryCodeNumLabel.text = country.codeNum
		
		self.dismissOverlay()
	}
}
