//
//  LanguageOverlayVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 13.11.18.
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
Controller for showing the usage of a language overlay.
*/
class LanguageOverlayVC: OverlayVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// If you select a language for which no localization exists (i.e. no ".lproj" folder), the fallback localization will be used
		// (That is what happens when you select Spanish as language in the example app)
		self.exampleDescriptionLabel.text = localizedString(for: "LOverlayVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
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
	
	override func createOverlay() {
		super.createOverlay()
		
		self.overlay = TRIKLanguageOverlay(superview: self.firstSubview,
										   text: localizedString(for: "LOverlayVC: Overlay Title", fallback: TRIKConstant.Language.Code.german),
										   titleFont: UIFont.boldSystemFont(ofSize: 20.0),
										   headerFont: UIFont.boldSystemFont(ofSize: 15.0),
										   contentFont: UIFont.systemFont(ofSize: 12.0),
										   style: self.selectedStyle,
										   position: self.position,
										   fallbackLanguage: "en",
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
// MARK: Language overlay delegate conformance
extension LanguageOverlayVC: TRIKLanguageOverlayDelegate {
	func overlay(_ overlay: TRIKLanguageOverlay, didSelectLanguage language: String) {
		// See application delegate for one possibility on how to perform a language change within the application
		// As an alternative, you can register for the notification "TRIKConstant.Notification.Name.languageOverlayDidSelectLanguage"
		// an retrieve the selected language from the notification's userInfo dictionary
		let delegate = UIApplication.shared.delegate as? AppDelegate
		delegate?.reloadUI()
	}
	
	func overlayDidCancel(_ overlay: TRIKLanguageOverlay) {
		self.overlay = nil
	}
}
