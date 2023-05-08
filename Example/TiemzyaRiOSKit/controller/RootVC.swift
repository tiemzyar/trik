//
//  RootVC.swift
//  TiemzyaRiOSKit_Example
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
import TiemzyaRiOSKit

// MARK: -
// MARK: Implementation
class RootVC: StatusBarStyleVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Button triggering a segue to the resource usage example
	@IBOutlet weak var utilityButton: UIButton!
	
	
	/// Label showing the controller stack count of the app's navigation controller
	@IBOutlet weak var navVCStackCountLabel: UILabel!
	
	/// References the controller's language overlay
	var languageOverlay: TRIKLanguageOverlay?

	// MARK: -
	// MARK: View lifecycle
	override func viewDidLoad() {
		self.titleLabel.text = localizedString(forKey: "RootVC: Title",
											   fallback: Locale.appFallbackLanguage)
		self.utilityButton.setTitle(localizedString(forKey: "RootVC: Button Utility",
													fallback: Locale.appFallbackLanguage),
									for: .normal)
		self.navVCStackCountLabel.text = "C: \(self.navigationController!.viewControllers.count)"
	}

	// MARK: -
	// MARK: Instance methods
	/**
	Displays an overlay for changing the application language.
	
	- parameters:
		- sender: Button triggering the method call
	*/
	@IBAction func languageButtonTapped(_ sender: UIButton) {
		if let overlay = self.languageOverlay {
			overlay .dismiss(animated: true) { (_) in
				overlay.destroy()
			}
			self.languageOverlay = nil
		}
		else {
			self.languageOverlay = TRIKLanguageOverlay(superview: self.firstSubview,
													   text: "Language Selection",
													   titleFont: UIFont.boldSystemFont(ofSize: 20.0),
													   headerFont: UIFont.boldSystemFont(ofSize: 15.0),
													   contentFont: UIFont.systemFont(ofSize: 12.0),
													   style: TRIKOverlay.Style.tiemzyar,
													   position: TRIKOverlay.Position.center,
													   fallbackLanguage: "en",
													   delegate: self)
			self.languageOverlay!.present(animated: true)
		}
	}

	// MARK: -
	// MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let button = sender as? UIButton, let destVC = segue.destination as? TRIKBaseVC {
			destVC.titleLabelText = button.title(for: .normal)
		}
		
	}

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
extension RootVC: TRIKLanguageOverlayDelegate {
	func overlay(_ overlay: TRIKLanguageOverlay, didSelectLanguage language: String) {
		// See application delegate for one possibility on how to perform a language change within the application
		let delegate = UIApplication.shared.delegate as? AppDelegate
		delegate?.reloadUI()
	}
	
	func overlayDidCancel(_ overlay: TRIKLanguageOverlay) {
		self.languageOverlay = nil
	}
}
