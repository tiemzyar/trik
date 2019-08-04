//
//  ISSOverlayVC.swift
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
Parent controller for all image slide show overlay examples.
*/
class ISSOverlayVC: OverlayVC {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Stores the paths of all images to show in the overlay
	private var imagePathsStored: [String]?
	var imagePaths: [String] {
		if self.imagePathsStored == nil {
			var paths: [String] = []
			for number in 1...54 {
				if let path = Bundle.main.path(forResource: "image-\(number)", ofType: TRIKConstant.FileManagement.FileExtension.jpg) {
					paths.append(path)
				}
			}
			self.imagePathsStored = paths
		}
		
		return self.imagePathsStored!
	}
	
	/// Stores all images to show in the overlay
	private var imagesStored: [UIImage]?
	var images: [UIImage] {
		if self.imagesStored == nil {
			var imgs: [UIImage] = []
			for path in self.imagePaths {
				if let img = UIImage(contentsOfFile: path) {
					imgs.append(img)
				}
			}
			self.imagesStored = imgs
		}
		
		return self.imagesStored!
	}
	
	/// Description label for the overlay's button style
	@IBOutlet weak var buttonStyleLabel: UILabel!
	
	/// Control for customizing the overlay's button style
	@IBOutlet weak var buttonStyleControl: UISegmentedControl!
	
	/// Description label for the overlay's button alpha level
	@IBOutlet weak var buttonAlphaLabel: UILabel!
	
	/// Control for customizing the overlay's button alpha level
	@IBOutlet weak var buttonAlphaControl: UISegmentedControl!
	
	/// Description label for the overlay's dismiss-enabled option
	@IBOutlet weak var dismissEnabledLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's dismiss-enabled option
	@IBOutlet weak var dismissSwitch: UISwitch!
	
	/// Description label for the overlay's paging-enabled option
	@IBOutlet weak var pagingEnabledLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's paging-enabled option
	@IBOutlet weak var pagingSwitch: UISwitch!
	
	/// Description label for the overlay's preload-images option
	@IBOutlet weak var preloadImagesLabel: UILabel!
	
	/// Switch for enabling / disabling the overlay's preload-images option
	@IBOutlet weak var preloadSwitch: UISwitch!
	
	/// Stores the selected button style for the overlay
	var selectedButtonStyle: TRIKStaticImageSlideShowOverlay.ButtonStyle = .roundedRect
	
	/// Stores the selected button alpha level for the overlay
	var selectedButtonAlpha: TRIKStaticImageSlideShowOverlay.ButtonAlphaLevel = .strong
	
	/// The overlay's designated superview
	@IBOutlet weak var slideShowSuperview: UIView!

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup.
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.buttonStyleLabel.text = localizedString(for: "ISSOverlayVC: Label Button Style", fallback: TRIKConstant.Language.Code.german)
		self.buttonAlphaLabel.text = localizedString(for: "ISSOverlayVC: Label Button Alpha", fallback: TRIKConstant.Language.Code.german)
		self.dismissEnabledLabel.text = localizedString(for: "ISSOverlayVC: Label Dismiss Enabled", fallback: TRIKConstant.Language.Code.german)
		self.pagingEnabledLabel.text = localizedString(for: "ISSOverlayVC: Label Paging Enabled", fallback: TRIKConstant.Language.Code.german)
		self.preloadImagesLabel.text = localizedString(for: "ISSOverlayVC: Label Preload Images", fallback: TRIKConstant.Language.Code.german)
		
		self.determineButtonStyle()
		self.determineButtonAlpha()
	}
	
	
	// MARK: -
	// MARK: Instance methods
	/**
	Reloads the overlay's slide show by updating its images respectively image paths, if the overlay is currently being presented.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func switchImages(_ sender: UIButton) {
		if let overlay = self.overlay as? TRIKImageSlideShowOverlay {
			let removeCount = 3
			if self.preloadSwitch.isOn {
				var imgs = overlay.images!
				if imgs.count - removeCount > 0 {
					imgs.removeFirst(3)
				}
				if imgs.count - removeCount > 0 {
					imgs.removeLast(3)
				}
				overlay.images = imgs
			}
			else {
				var paths = overlay.imagePaths!
				if paths.count - removeCount > 0 {
					paths.removeFirst(3)
				}
				if paths.count - removeCount > 0 {
					paths.removeLast(3)
				}
				overlay.imagePaths = paths
			}
		}
	}
	/**
	Determines the button style to use for the overlay.
	*/
	func determineButtonStyle() {
		switch self.buttonStyleControl.selectedSegmentIndex {
		case TRIKStaticImageSlideShowOverlay.ButtonStyle.circle.rawValue:
			self.selectedButtonStyle = .circle
		case TRIKStaticImageSlideShowOverlay.ButtonStyle.rect.rawValue:
			self.selectedButtonStyle = .rect
		case TRIKStaticImageSlideShowOverlay.ButtonStyle.roundedRect.rawValue:
			self.selectedButtonStyle = .roundedRect
		default:
			self.selectedButtonStyle = .roundedRect
		}
	}
	
	/**
	Determines the button alpha level to use for the overlay.
	*/
	func determineButtonAlpha() {
		switch self.buttonAlphaControl.selectedSegmentIndex {
		case 0:
			self.selectedButtonAlpha = .weak
		case 1:
			self.selectedButtonAlpha = .medium
		case 2:
			self.selectedButtonAlpha = .strong
		default:
			self.selectedButtonAlpha = .full
		}
	}
	
	@IBAction override func colorStyleDidChange(_ sender: UISegmentedControl) {
		super.colorStyleDidChange(sender)
		
		self.dismissOverlay(recreate: true)
	}
	
	@IBAction override func positionDidChange(_ sender: UISegmentedControl) {
		super.positionDidChange(sender)
		
		self.dismissOverlay(recreate: true)
	}
	
	/**
	Reacts to changes of the overlay's button style.
	
	- parameters:
		- sender: The control triggering the method call
	*/
	@IBAction func buttonStyleDidChange(_ sender: UISegmentedControl) {
		self.determineButtonStyle()
		
		self.dismissOverlay(recreate: true)
	}
	
	/**
	Reacts to changes of the overlay's button alpha level.
	
	- parameters:
		- sender: The control triggering the method call
	*/
	@IBAction func buttonAlphaDidChange(_ sender: UISegmentedControl) {
		self.determineButtonAlpha()
		
		self.dismissOverlay(recreate: true)
	}
	
	/**
	Reacts to changes of the following options of the overlay:
	- dismiss-enabled
	- paging-enabled
	- preload-images
	
	- parameters:
		- sender: The switch triggering the method call
	*/
	@IBAction func switchValueDidChange(_ sender: UISwitch) {
		self.dismissOverlay(recreate: true)
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
// MARK: Image slide show overlay delegate conformance
extension ISSOverlayVC: TRIKImageSlideShowOverlayDelegate {
	func overlayDidDismiss(_ overlay: TRIKImageSlideShowOverlay) {
		self.overlay = nil
	}
}
