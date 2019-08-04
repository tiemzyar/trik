//
//  UtilityVC.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 25.09.18.
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

import UIKit
import TiemzyaRiOSKit

/**
Controller for showing the usage of TRIK framework utilities and resources.
*/
class UtilityVC: ExampleVC {
	// MARK: Nested types
	
	
	// MARK: Type properties
	
	
	// MARK: Type methods
	
	
	// MARK: -
	// MARK: Instance properties
	/// Description label for using localized strings from the TRIK framework
	@IBOutlet weak var stringUsageDescLabel: UILabel!
	
	/// Displays a localized string from the TRIK framework
	@IBOutlet weak var localizedStringLabel: UILabel!
	
	/// Description label for using image resources from the TRIK framework
	@IBOutlet weak var imageUsageDescLabel: UILabel!
	
	/// Displays an image from the TRIK framework
	@IBOutlet weak var resourceIV: UIImageView!
	
	// MARK: -
	// MARK: View lifecycle
	/**
	Shows usage of utilities and resources.
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Use TRIK constants
		let code = TRIKConstant.Language.Code.german
		
		// Use debug log function (does not log in release configuration) ...
		devLog("\(code)")
		// ... in contrast to standard print
		print("Print: \(code)")
		
		// Retrieve ISO 639-1 language code for the current application language ...
		print("Current language: \(currentLanguage())")
		// ... with optional fallback (if current language does not match any entry in a list of application languages)
		print("Current language: \(currentLanguage(withFallback: TRIKConstant.Language.Code.german))")
		
		// Retrieve localized strings from Localizable.strings of app bundle
		self.exampleDescriptionLabel.text = localizedString(for: "RUseVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
		self.stringUsageDescLabel.text = localizedString(for: "RUseVC: Label String Usage Desc", fallback: TRIKConstant.Language.Code.german)
		self.imageUsageDescLabel.text = localizedString(for: "RUseVC: Label Image Usage Desc", fallback: TRIKConstant.Language.Code.german)
		
		// Retrieve localized strings from TRIK framework
		self.localizedStringLabel.text = localizedString(for: "CSOverlay: Search Bar Placeholder",
														 in: TRIKUtil.trikResourceBundle() ?? Bundle.main,
														 and: "TRIKLocalizable",
														 fallback: TRIKConstant.Language.Code.english)
		
		// Use TRIK image resources
		if let imagePath = TRIKUtil.trikResourceBundle()?.path(forResource: "TRIKSliderThumbImageBlue", ofType: TRIKConstant.FileManagement.FileExtension.png) {
			if let image = UIImage(contentsOfFile: imagePath) {
				self.resourceIV.image = image
			}
		}
	}
	
	// MARK: -
	// MARK: Instance methods
	
	
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

