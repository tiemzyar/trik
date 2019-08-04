//
//  AlertControllerExtVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 14.11.18.
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
Controller for showing the usage of the TRIK framework's alert controller extension.
*/
class AlertControllerExtVC: ExampleVC {
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
		
		self.exampleDescriptionLabel.text = localizedString(for: "ACExtVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Creates an examplary action sheet.
	
	- parameters:
		- sender: The button or bar button triggering the method call
	*/
	@IBAction func testActionSheet(_ sender: Any) {
		let locAlertTitle = localizedString(for: "ACExtVC: ActionSheet Test Title", fallback: TRIKConstant.Language.Code.english)
		let locButtonTitleDestruct = localizedString(for: "ACExtVC: ActionSheet Test Button Destructive", fallback: TRIKConstant.Language.Code.english)
		let locButtonTitleCancel = localizedString(for: "ACExtVC: ActionSheet Test Button Cancel", fallback: TRIKConstant.Language.Code.english)
		
		let testAS = UIAlertController(title: locAlertTitle,
									   message: nil,
									   preferredStyle: UIAlertControllerStyle.actionSheet)
		var action = UIAlertAction(title: locButtonTitleDestruct,
								   style: UIAlertActionStyle.destructive,
								   handler: { [weak testAS] (destructiveAction) in
									devLog("Destroyed")
									testAS?.dismiss()
		})
		testAS.addAction(action)
		action = UIAlertAction(title: locButtonTitleCancel,
							   style: UIAlertActionStyle.cancel,
							   handler: { [weak testAS] (cancelAction) in
								devLog("Cancelled")
								testAS?.dismiss()
		})
		testAS.addAction(action)
		
		if let ppc = testAS.popoverPresentationController {
			if let button = sender as? UIBarButtonItem {
				ppc.barButtonItem = button
			}
			else if let button = sender as? UIButton {
				ppc.sourceView = button
				ppc.sourceRect = button.bounds
			}
			
			ppc.permittedArrowDirections = .any
		}
		
		// Notice that you can just show this alert controller from anywhere within your code,
		// without the need for having a view controller around for presentation
		testAS.show(animated: true)
	}
	
	/**
	Creates an examplary alert.
	
	- parameters:
		- sender: The button or bar button triggering the method call
	*/
	@IBAction func testAlert(_ sender: Any) {
		let locAlertTitle = localizedString(for: "ACExtVC: Alert Test Title", fallback: TRIKConstant.Language.Code.english)
		let locAlertMessage = localizedString(for: "ACExtVC: Alert Test Message", fallback: TRIKConstant.Language.Code.english)
		let locButtonTitleDestruct = localizedString(for: "ACExtVC: Alert Test Button Destructive", fallback: TRIKConstant.Language.Code.english)
		let locButtonTitleCancel = localizedString(for: "ACExtVC: Alert Test Button Cancel", fallback: TRIKConstant.Language.Code.english)
		
		let testAlert = UIAlertController(title: locAlertTitle,
										  message: locAlertMessage,
										  preferredStyle: UIAlertControllerStyle.alert)
		var action = UIAlertAction(title: locButtonTitleDestruct,
								   style: UIAlertActionStyle.destructive,
								   handler: { [weak testAlert] (destructiveAction) in
									devLog("Destroyed")
									testAlert?.dismiss()
		})
		testAlert.addAction(action)
		action = UIAlertAction(title: locButtonTitleCancel,
							   style: UIAlertActionStyle.cancel,
							   handler: { [weak testAlert] (cancelAction) in
								devLog("Cancelled")
								testAlert?.dismiss()
		})
		testAlert.addAction(action)
		
		// Notice that you can just show this alert controller from anywhere within your code,
		// without the need for having a view controller around for presentation
		testAlert.show(animated: true)
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
