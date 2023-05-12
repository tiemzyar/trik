//
//  OverlayTestBase.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 11.05.23.
//  Copyright © 2023 tiemzyar. All rights reserved.
//

import UIKit
import XCTest

@testable import TiemzyaRiOSKit

/**
Base class providing common functionality for overlay test classes.
*/
class OverlayTestBase: CommonTestBase {
	// MARK: Nested types


	// MARK: Type properties
	static let controllerNavID = "NavVC"
	static let testFontContent = UIFont(name: "Avenir-Black", size: 15.0)!
	static let testFontHeader = UIFont(name: "Avenir-Heavy", size: 18.0)!
	static let testString = "Some plain text"
	static let testStringLong = """
		Lorem ipsum dolor sit amet, quo viris iudico in, te eos elitr nostrud, te est audiam comprehensam. Pro voluptua delicata ad, nam an autem deleniti, usu atqui quando nominati id. Ei quo debitis convenire. Duo suas salutatus ad, quo graece delenit te.
		
		Aliquid perpetua convenire per cu, mei ei vero utinam, sed et virtute mentitum indoctum. Cu adolescens mnesarchum nec. Ea labores platonem sententiae pri, ea amet mutat oportere sit, pri ad nostrud platonem. Cu usu eius rationibus. Cu dico assum mel, tempor molestie periculis eam at. Quo at omnes legendos scripserit, ad nemore saperet mei, ne sed liber harum nostrud. Latine reprimique scribentur at mea, consulatu efficiantur qui id.
		"""

	// MARK: Instance properties
	var navVC: UINavigationController!
	var controller: UIViewController!
	var overlay: TRIKOverlay!
}

// MARK: -
// MARK: Setup and tear-down
extension OverlayTestBase {
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		// Get test storyboard and view controllers for testing
		let storyboard = UIStoryboard(name: "TestStoryboard", bundle: Bundle(for: CountryOverlayTests.self))
		
		guard let nvc = storyboard.instantiateViewController(withIdentifier: CountryOverlayTests.controllerNavID) as? UINavigationController else {
			return
		}
		self.navVC = nvc
		
		guard let rvc = self.navVC.viewControllers.first else {
			return
		}
		self.controller = rvc
		// Preload controller's view
		_ = self.controller.view
	}
	
	override func tearDownWithError() throws {
		if self.overlay != nil {
			self.overlay.dismiss(animated: false) { [unowned self] (_) in
				self.overlay.destroy()
			}
			self.overlay = nil
		}
		
		self.controller = nil
		self.navVC = nil
		
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Supporting methods
extension OverlayTestBase {
	func presentAndLayoutControllerView() {
		self.controller.viewWillAppear(false)
		self.controller.view.layoutIfNeeded()
	}
}
