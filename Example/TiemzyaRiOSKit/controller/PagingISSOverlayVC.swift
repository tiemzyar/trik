//
//  PagingISSOverlayVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 28.11.18.
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
Controller for showing the usage of a paging image slide show overlay.
*/
class PagingISSOverlayVC: ISSOverlayVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Description label for the overlay's dual-layout option
	@IBOutlet weak var dualLayoutLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's dual-layout option
	@IBOutlet weak var dualLayoutSwitch: UISwitch!
	
	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.exampleDescriptionLabel.text = localizedString(for: "PISSOverlayVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
		self.dualLayoutLabel.text = localizedString(for: "PISSOverlayVC: Label Dual Layout", fallback: TRIKConstant.Language.Code.german)
    }

	// MARK: -
	// MARK: Instance methods
	override func createOverlay() {
		/*
		Supported gestures:
		- Swipe left or right to change image (when presenting more than one image)
		- Pinch to zoom (if image dimensions allow zoom)
		- One finger double tap to zoon in (again, if image dimensions allow zoom)
		- Two finger double tap to zoom out (again, if image dimensions allow zoom)
		*/
		super.createOverlay()
		if self.preloadSwitch.isOn {
			self.overlay = TRIKPagingImageSlideShowOverlay(images: self.images,
														   superview: self.slideShowSuperview,
														   font: UIFont.boldSystemFont(ofSize: 20.0),
														   style: self.selectedStyle,
														   position: self.position,
														   buttonStyle: self.selectedButtonStyle,
														   buttonAlpha: self.selectedButtonAlpha,
														   dismissButton: self.dismissSwitch.isOn,
														   pagingButtons: self.pagingSwitch.isOn,
														   dualImageLayout: self.dualLayoutSwitch.isOn,
														   delegate: self)
		}
		else {
			// When passing image paths to the slide show overlay and one of the images does not exist or is somehow broken,
			// the overlay will show a (localized) information about a broken image
			// (see image-5.jpg in the example app)
			self.overlay = TRIKPagingImageSlideShowOverlay(imagePaths: self.imagePaths,
														   superview: self.slideShowSuperview,
														   font: UIFont.boldSystemFont(ofSize: 20.0),
														   style: self.selectedStyle,
														   position: self.position,
														   buttonStyle: self.selectedButtonStyle,
														   buttonAlpha: self.selectedButtonAlpha,
														   dismissButton: self.dismissSwitch.isOn,
														   pagingButtons: self.pagingSwitch.isOn,
														   dualImageLayout: self.dualLayoutSwitch.isOn,
														   delegate: self)
		}
		
		let overlay = self.overlay as! TRIKPagingImageSlideShowOverlay
		
		overlay.present(animated: true)
	}

	// MARK: -
	// MARK: Navigation
	

	// MARK: -
	// MARK: Interface changes
	/**
	Updates the content offset of the overlay's scroll view.
	
	This is necessary to display the correct image(s) in the overlay after orientation and / or size changes of the controller's view.
	*/
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		coordinator.animate(alongsideTransition: { (_) in }) { (_) in
			if let overlay = self.overlay as? TRIKPagingImageSlideShowOverlay {
				UIView.animate(withDuration: TRIKConstant.AnimationTime.short, animations: {
					overlay.updateContentOffset()
				})
			}
		}
	}

	// MARK: -
	// MARK: Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
