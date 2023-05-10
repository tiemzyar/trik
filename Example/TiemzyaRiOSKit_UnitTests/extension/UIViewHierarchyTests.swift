//
//  UIViewHierarchyTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by Tary M. Z. Ramon on 10.05.23.
//  Copyright © 2023 tiemzyar. All rights reserved.
//

import UIKit
import XCTest

@testable import TiemzyaRiOSKit

/**
Unit test class for ``UIView+Hierarchy``.
*/
class UIViewHierarchyTests: CommonTestBase {
}

// MARK: -
// MARK: Setup and tear-down
extension UIViewHierarchyTests {
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
}

// MARK: -
// MARK: Supporting methods
extension UIViewHierarchyTests {
	private func addSubviews<T : UIView>(ofType type: T.Type,
										 to view: UIView,
										 hierarchyLevelCount: Int,
										 countPerLevel: Int) -> UIView {
		
		var currentView = view
		for _ in 1 ... hierarchyLevelCount {
			var lastSubviewOfLevel: UIView!
			for _ in 1 ... countPerLevel {
				lastSubviewOfLevel = T()
				currentView.addSubview(lastSubviewOfLevel)
			}
			currentView = lastSubviewOfLevel
		}
		
		// Returns last added subview at last level in subview hierachy
		return currentView
	}
	
	private func addSuperviews<T : UIView>(ofType type: T.Type, to view: UIView, hierarchyLevelCount: Int) -> UIView {
		var currentView = view
		for _ in 1 ... hierarchyLevelCount {
			let superview = T()
			superview.addSubview(currentView)
			currentView = superview
		}
		
		// Returns last added superview in superview hierachy
		return currentView
	}
}

// MARK: -
// MARK: Assertion methods
extension UIViewHierarchyTests {
	private func assertSubviews<T : UIView>(of view: UIView,
											forType type: T.Type,
											withRecursion recursive: Bool,
											expectedCount: Int) {
		
		let subviews = view.getSubviews(ofType: type, recursive: recursive)
		XCTAssertEqual(subviews.count, expectedCount,
					   "Subview count for type '\(type)' does not match expected count")
	}
	
	private func assertSuperviews<T : UIView>(of view: UIView, forType type: T.Type, expectedCount: Int) {
		let superviews = view.getSuperviews(ofType: type)
		XCTAssertEqual(superviews.count, expectedCount,
					   "Superview count for type '\(type)' does not match expected count")
	}
}

// MARK: -
// MARK: Controller tests
extension UIViewHierarchyTests {
	func test_findingController_nonexistent() {
		let view = UIView()
		let lastSuperview = self.addSuperviews(ofType: UIView.self, to: view, hierarchyLevelCount: 10)
		_ = lastSuperview
		
		let controller = view.findViewController()
		XCTAssertNil(controller)
	}
	
	func test_findingController_exists() {
		let view = UIView()
		let lastSuperview = self.addSuperviews(ofType: UIView.self, to: view, hierarchyLevelCount: 10)
		_ = lastSuperview
		
		let expectedController = UIViewController()
		let controllerView = expectedController.view
		controllerView?.addSubview(lastSuperview)
		
		let controller = view.findViewController()
		XCTAssertEqual(controller, expectedController)
	}
}

// MARK: -
// MARK: Subview tests
extension UIViewHierarchyTests {
	func test_gettingSubviews_noSubviews() {
		let view = UIView()
		self.assertSubviews(of: view, forType: UIView.self, withRecursion: false, expectedCount: 0)
		self.assertSubviews(of: view, forType: UIView.self, withRecursion: true, expectedCount: 0)
	}
	
	func test_gettingSubviews_withSubviews_noneOfRelevantType() {
		let view = UIView()
		
		let lastLabelSubview = self.addSubviews(ofType: UILabel.self,
												to: view,
												hierarchyLevelCount: 5,
												countPerLevel: 3)
		let lastTextViewSubview = self.addSubviews(ofType: UITextView.self,
												   to: lastLabelSubview,
												   hierarchyLevelCount: 5,
												   countPerLevel: 3)
		let lastTextFieldSubview = self.addSubviews(ofType: UITextField.self,
													to: lastTextViewSubview,
													hierarchyLevelCount: 5,
													countPerLevel: 3)
		let _ = lastTextFieldSubview
		
		self.assertSubviews(of: view, forType: UIButton.self, withRecursion: false, expectedCount: 0)
		self.assertSubviews(of: view, forType: UIButton.self, withRecursion: true, expectedCount: 0)
		self.assertSubviews(of: view, forType: UIStackView.self, withRecursion: false, expectedCount: 0)
		self.assertSubviews(of: view, forType: UIStackView.self, withRecursion: true, expectedCount: 0)
		self.assertSubviews(of: view, forType: UITableView.self, withRecursion: false, expectedCount: 0)
		self.assertSubviews(of: view, forType: UITableView.self, withRecursion: true, expectedCount: 0)
	}
	
	func test_gettingSubviews_withSubviews_someOfRelevantType() {
		let view = UIView()
		
		let subviewCountPerLevel = 3
		
		let lastLabelSubview = self.addSubviews(ofType: UILabel.self,
												to: view,
												hierarchyLevelCount: 5,
												countPerLevel: subviewCountPerLevel)
		let buttonHierarchyLevels = 7
		let lastButtonSubview = self.addSubviews(ofType: UIButton.self,
												 to: lastLabelSubview,
												 hierarchyLevelCount: buttonHierarchyLevels,
												 countPerLevel: subviewCountPerLevel)
		let lastTextFieldSubview = self.addSubviews(ofType: UITextField.self,
													to: lastButtonSubview,
													hierarchyLevelCount: 5,
													countPerLevel: subviewCountPerLevel)
		let tableViewHierarchyLevels = 9
		let lastTableViewSubview = self.addSubviews(ofType: UITableView.self,
													to: lastTextFieldSubview,
													hierarchyLevelCount: tableViewHierarchyLevels,
													countPerLevel: subviewCountPerLevel)
		let _ = lastTableViewSubview
		
		self.assertSubviews(of: lastLabelSubview, forType: UIButton.self, withRecursion: false,
							expectedCount: subviewCountPerLevel)
		self.assertSubviews(of: view, forType: UIButton.self, withRecursion: true,
							expectedCount: subviewCountPerLevel * buttonHierarchyLevels)
		self.assertSubviews(of: view, forType: UIStackView.self, withRecursion: false, expectedCount: 0)
		self.assertSubviews(of: view, forType: UIStackView.self, withRecursion: true, expectedCount: 0)
		self.assertSubviews(of: lastTextFieldSubview, forType: UITableView.self, withRecursion: false,
							expectedCount: subviewCountPerLevel)
		self.assertSubviews(of: view, forType: UITableView.self, withRecursion: true,
							expectedCount: subviewCountPerLevel * tableViewHierarchyLevels)
	}
	
	func test_gettingSubviews_withSubviews_allOfRelevantType() {
		let view = UIView()
		
		let subviewCountPerLevel = 3
		
		let textViewHiearchyLevels = 4
		let lastTextViewSubview = self.addSubviews(ofType: UITextView.self,
												   to: view,
												   hierarchyLevelCount: textViewHiearchyLevels,
												   countPerLevel: subviewCountPerLevel)
		let tableViewHierarchyLevels = 7
		let lastTableViewSubview = self.addSubviews(ofType: UITableView.self,
													to: lastTextViewSubview,
													hierarchyLevelCount: tableViewHierarchyLevels,
													countPerLevel: subviewCountPerLevel)
		let scrollViewHierarchyLevels = 9
		let lastScrollViewSubview = self.addSubviews(ofType: UITableView.self,
													 to: lastTableViewSubview,
													 hierarchyLevelCount: scrollViewHierarchyLevels,
													 countPerLevel: subviewCountPerLevel)
		let _ = lastScrollViewSubview
		
		self.assertSubviews(of: view, forType: UIScrollView.self, withRecursion: false,
							expectedCount: subviewCountPerLevel)
		var expectedCount = textViewHiearchyLevels * subviewCountPerLevel
							+ tableViewHierarchyLevels * subviewCountPerLevel
							+ scrollViewHierarchyLevels * subviewCountPerLevel
		self.assertSubviews(of: view, forType: UIScrollView.self, withRecursion: true, expectedCount: expectedCount)
		
		self.assertSubviews(of: lastTextViewSubview, forType: UIScrollView.self, withRecursion: false,
							expectedCount: subviewCountPerLevel)
		expectedCount = tableViewHierarchyLevels * subviewCountPerLevel
						+ scrollViewHierarchyLevels * subviewCountPerLevel
		self.assertSubviews(of: lastTextViewSubview, forType: UIScrollView.self, withRecursion: true,
							expectedCount: expectedCount)
		
		self.assertSubviews(of: lastTableViewSubview, forType: UIScrollView.self, withRecursion: false,
							expectedCount: subviewCountPerLevel)
		expectedCount = scrollViewHierarchyLevels * subviewCountPerLevel
		self.assertSubviews(of: lastTableViewSubview, forType: UIScrollView.self, withRecursion: true,
							expectedCount: expectedCount)
	}
}

// MARK: -
// MARK: Superview tests
extension UIViewHierarchyTests {
	func test_gettingSuperviews_noSuperviews() {
		let view = UIView()
		self.assertSuperviews(of: view, forType: UIView.self, expectedCount: 0)
	}
	
	func test_gettingSuperviews_withSuperviews_noneOfRelevantType() {
		let view = UIView()
		
		let lastLabelSuperview = self.addSuperviews(ofType: UILabel.self, to: view, hierarchyLevelCount: 5)
		let lastTextViewSuperview = self.addSuperviews(ofType: UITextView.self,
													   to: lastLabelSuperview,
													   hierarchyLevelCount: 5)
		let lastTFSuperview = self.addSuperviews(ofType: UITextField.self,
												 to: lastTextViewSuperview,
												 hierarchyLevelCount: 5)
		let _ = lastTFSuperview
		
		self.assertSuperviews(of: view, forType: UIButton.self, expectedCount: 0)
		self.assertSuperviews(of: view, forType: UIStackView.self, expectedCount: 0)
		self.assertSuperviews(of: view, forType: UITableView.self, expectedCount: 0)
	}
	
	func test_gettingSuperviews_withSuperviews_someOfRelevantType() {
		let view = UIView()
		
		let lastLabelSuperview = self.addSuperviews(ofType: UILabel.self, to: view, hierarchyLevelCount: 5)
		let expectedButtonCount = 7
		let lastButtonSuperview = self.addSuperviews(ofType: UIButton.self,
												 to: lastLabelSuperview,
												 hierarchyLevelCount: expectedButtonCount)
		let lastTFSuperview = self.addSuperviews(ofType: UITextField.self,
												 to: lastButtonSuperview,
												 hierarchyLevelCount: 5)
		let expectedTableViewCount = 9
		let lastTableViewSuperview = self.addSuperviews(ofType: UITableView.self,
														to: lastTFSuperview,
														hierarchyLevelCount: expectedTableViewCount)
		let _ = lastTableViewSuperview
		
		self.assertSuperviews(of: view, forType: UIButton.self, expectedCount: expectedButtonCount)
		self.assertSuperviews(of: view, forType: UIStackView.self, expectedCount: 0)
		self.assertSuperviews(of: view, forType: UITableView.self, expectedCount: expectedTableViewCount)
	}
	
	func test_gettingSuperviews_withSuperviews_allOfRelevantType() {
		let view = UIView()
		
		let textViewCount = 6
		let lastTextViewSuperview = self.addSuperviews(ofType: UITextView.self,
													   to: view,
													   hierarchyLevelCount: textViewCount)
		let tableViewCount = 9
		let lastTableViewSuperview = self.addSuperviews(ofType: UITableView.self,
														to: lastTextViewSuperview,
														hierarchyLevelCount: tableViewCount)
		let scrollViewCount = 4
		let lastScrollViewSuperview = self.addSuperviews(ofType: UIScrollView.self,
														 to: lastTableViewSuperview,
														 hierarchyLevelCount: scrollViewCount)
		let _ = lastScrollViewSuperview
		
		let expectedSuperviewCount = textViewCount + tableViewCount + scrollViewCount
		
		self.assertSuperviews(of: view, forType: UIScrollView.self, expectedCount: expectedSuperviewCount)
	}
}
