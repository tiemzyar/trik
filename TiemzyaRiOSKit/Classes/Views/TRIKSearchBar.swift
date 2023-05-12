//
//  TRIKSearchBar.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 28.10.18.
//  Copyright © 2018-2023 tiemzyar.
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
import QuartzCore

// MARK: -
// MARK: Implementation
/**
A custom implementation of a UISearchBar like search bar.
*/
public class TRIKSearchBar: UIView {
	// MARK: Nested types


	// MARK: Type properties
	/// Corner radius of the search bar
	internal static let cornerRadius: CGFloat = 5.0
	
	/// Default height of the search bar
	public static let defaultHeight: CGFloat = 50.0
	
	/// Default padding between the search bar and its subviews
	public static let defaultPadding: CGFloat = 0.0
	
	/// Minimum width of the search bar's search field
	private static let searchFieldMinWidth: CGFloat = 150.0
	
	/// Padding between the search bar's search field and its left view
	private static let searchFieldPaddingLeftView: CGFloat = 5.0
	
	/// Padding between the search bar's search field and its right view
	private static let searchFieldPaddingRightView: CGFloat = 5.0
	
	/// Spacing between the search bar'S subviews
	private static let subviewSpacing: CGFloat = 10.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// The search bar's delegate, responsible for processing search entries
	public var delegate: TRIKSearchBarDelegate?
	
	/// The search bar's search field
	public let searchField: UITextField
	
	/// The icon acting as left view of the search bar's search field
	public private (set) var searchIcon: UIImageView?
	
	/// The button acting as right view of the search bar's search field
	public private (set) var clearButton: UIButton?
	
	/// The search bar's cancel button
	public let cancelButton: UIButton
	
	/// Layout constraint for the width of the search bar's cancel button
	private var constraintCancelButtonWidth: NSLayoutConstraint!
	
	/// Stores the height of the search bar's search field
	internal private (set) var searchFieldHeight: CGFloat
	
	/// Calculates the side length of the left view of the search bar's search field subject to the search field's height
	private var searchFieldLeftViewLength: CGFloat {
		get {
			var factor: CGFloat = 0.0
			switch self.searchFieldHeight {
			case let x where x <= 30.0:
				factor = 1.0
			case let x where x <= 35.0:
				factor = 0.9
			case let x where x <= 40.0:
				factor = 0.85
			case let x where x <= 45.0:
				factor = 0.8
			default:
				factor = 0.75
			}
			
			return self.searchFieldHeight * factor
		}
	}
	
	/// Stores the padding between the search bar and its subviews
	internal private (set) var searchFieldPadding: CGFloat
	
	/// Calculates the side length of the right view of the search bar's search field subject to the search field's height
	private var searchFieldRightViewLength: CGFloat {
		get {
			var factor: CGFloat = 0.0
			switch self.searchFieldHeight {
			case let x where x <= 35.0:
				factor = 1.0
			case let x where x <= 40.0:
				factor = 0.8
			default:
				factor = 0.75
			}
			
			return self.searchFieldHeight * factor
		}
	}
	
	/// Flag about whether or not the search bar should show its cancel button
	public var showsCancelButton: Bool {
		willSet {
			if newValue == true {
				NSLayoutConstraint.deactivate([self.constraintCancelButtonWidth])
			}
			else {
				NSLayoutConstraint.activate([self.constraintCancelButtonWidth])
			}
			
			UIView.animate(withDuration: TRIKConstant.AnimationTime.medium) {
				self.layoutIfNeeded()
			}
		}
	}
	
	/// Flag about whether or not the search bar's search field should show its clear button
	public var showsClearButton: Bool {
		willSet {
			if newValue == true {
				self.searchField.rightViewMode = .always
			}
			else {
				self.searchField.rightViewMode = .never
			}
		}
	}
	
	/// Flag about whether or not the search bar's corners should be rounded
	internal private (set) var roundCorners: Bool

	// MARK: -
	// MARK: View lifecycle
	public convenience required init?(coder aDecoder: NSCoder) {
		let message = """
						Warning:
						This initializer does not return a working instance of \(String(describing: TRIKSearchBar.self)), but will always return nil.
						Use init(frame:
									delegate:
									headerFont:
									searchFieldHeight:
									searchFieldPadding:
									roundCorners:)
						instead!
						"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the search bar.
	
	Initializes the search bar's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- frame: Frame to set for the search bar
		- delegate: The search bar's delegate for processing search entries
		- height: Height for the search bar's search field
		- padding: Padding between the search bar and its subviews
		- rounded: Flag about whether or not the search bar's corners should be rounded
	
	- returns: A fully set up instance of TRIKSearchBar
	*/
	public init(frame: CGRect = CGRect.zero,
	            delegate: TRIKSearchBarDelegate? = nil,
	            searchFieldHeight height: CGFloat = TRIKSearchBar.defaultHeight,
	            searchFieldPadding padding: CGFloat = TRIKSearchBar.defaultPadding,
	            roundCorners rounded: Bool = false) {
		
		self.delegate = delegate
		self.searchFieldHeight = height
		self.searchFieldPadding = padding
		self.roundCorners = rounded
		
		self.searchField = UITextField(frame: CGRect.zero)
		self.showsCancelButton = false
		self.showsClearButton = false
		self.cancelButton = UIButton(frame: CGRect.zero)
		
		super.init(frame: frame)
		
		self.setup()
	}

	// MARK: -
	// MARK: Instance methods
	
	
}

// MARK: -
// MARK: Setup and customization
extension TRIKSearchBar {
	/**
	Sets up the search bar.
	*/
	private func setup() {
		if self.roundCorners {
			self.layer.cornerRadius = TRIKSearchBar.cornerRadius
			self.clipsToBounds = true
		}
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the layout of the search bar's subviews.
	*/
	private func setupSubviewLayout() {
		// Search text field
		self.searchField.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(searchField)
		
		let minWidth = self.searchField.widthAnchor.constraint(greaterThanOrEqualToConstant: TRIKSearchBar.searchFieldMinWidth)
		minWidth.priority = UILayoutPriority(rawValue: 750)
		minWidth.isActive = true
		self.searchField.heightAnchor.constraint(equalToConstant: self.searchFieldHeight).isActive = true
		self.searchField.topAnchor.constraint(equalTo: self.topAnchor,
											  constant: self.searchFieldPadding).isActive = true
		self.searchField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
												  constant: self.searchFieldPadding).isActive = true
		self.searchField.bottomAnchor.constraint(equalTo: self.bottomAnchor,
												 constant: -self.searchFieldPadding).isActive = true
		
		// Cancel button
		self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
		self.cancelButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
		self.cancelButton.setContentHuggingPriority(UILayoutPriority(rawValue: 999), for: .horizontal)
		self.cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: TRIKSearchBar.subviewSpacing, bottom: 0.0, right: TRIKSearchBar.subviewSpacing)
		self.addSubview(self.cancelButton)
		
		self.constraintCancelButtonWidth = self.cancelButton.widthAnchor.constraint(equalToConstant: 0)
		self.constraintCancelButtonWidth.isActive = true
		
		self.cancelButton.topAnchor.constraint(equalTo: self.searchField.topAnchor).isActive = true
		self.cancelButton.leadingAnchor.constraint(equalTo: self.searchField.trailingAnchor).isActive = true
		self.cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
													constant: -self.searchFieldPadding).isActive = true
		self.cancelButton.bottomAnchor.constraint(equalTo: self.searchField.bottomAnchor).isActive = true
	}
	
	/**
	Customizes the search bar's subviews.
	*/
	private func customize() {
		// Search field
		self.searchField.addTarget(self, action: #selector(TRIKSearchBar.searchFieldDidBeginEditing(_:)), for: UIControl.Event.editingDidBegin)
		self.searchField.addTarget(self, action: #selector(TRIKSearchBar.searchFieldDidEndEditing(_:)), for: .editingDidEnd)
		self.searchField.addTarget(self, action: #selector(TRIKSearchBar.searchFieldTextDidChange(_:)), for: UIControl.Event.editingChanged)
		self.searchField.addTarget(self, action: #selector(TRIKSearchBar.searchFieldDidReturn(_:)), for: UIControl.Event.editingDidEndOnExit)
		
		// Search field left view
		let leftViewFrame = CGRect(x: 0.0,
		                           y: 0.0,
		                           width: self.searchFieldLeftViewLength,
		                           height: self.searchFieldLeftViewLength)
		let leftViewImageFrame = CGRect(x: TRIKSearchBar.searchFieldPaddingLeftView,
		                                y: TRIKSearchBar.searchFieldPaddingLeftView,
		                                width: self.searchFieldLeftViewLength - 2 * TRIKSearchBar.searchFieldPaddingLeftView,
		                                height: self.searchFieldLeftViewLength - 2 * TRIKSearchBar.searchFieldPaddingLeftView)
		let leftView = UIView(frame: leftViewFrame)
		self.searchIcon = UIImageView(frame: leftViewImageFrame)
		self.searchIcon!.contentMode = .scaleAspectFit
		let searchImage = UIImage(named: "TRIKButtonSearch", in: TRIKUtil.trikResourceBundle(), compatibleWith: nil)
		self.searchIcon!.image = searchImage
		leftView.addSubview(self.searchIcon!)
		self.searchField.leftView = leftView
		self.searchField.leftViewMode = .always
		
		// Search field right view
		let rightViewFrame = CGRect(x: 0.0,
		                           y: 0.0,
		                           width: self.searchFieldRightViewLength,
		                           height: self.searchFieldRightViewLength)
		let rightViewImageFrame = CGRect(x: TRIKSearchBar.searchFieldPaddingRightView,
		                                 y: TRIKSearchBar.searchFieldPaddingRightView,
		                                 width: self.searchFieldRightViewLength - 2 * TRIKSearchBar.searchFieldPaddingRightView,
		                                 height: self.searchFieldRightViewLength - 2 * TRIKSearchBar.searchFieldPaddingRightView)
		let rightView = UIView(frame: rightViewFrame)
		self.clearButton = UIButton(frame: rightViewImageFrame)
		let clearImage = UIImage(named: "TRIKButtonClear", in: TRIKUtil.trikResourceBundle(), compatibleWith: nil)
		self.clearButton!.setBackgroundImage(clearImage, for: UIControl.State.normal)
		self.clearButton!.addTarget(self, action: #selector(TRIKSearchBar.clearButtonTapped(_:)), for: .touchUpInside)
		rightView.addSubview(self.clearButton!)
		self.searchField.rightView = rightView
		self.searchField.rightViewMode = .never
		
		// Cancel button
		self.cancelButton.setTitleColor(TRIKConstant.Color.black, for: .normal)
		self.cancelButton.setTitle(localizedString(forKey: "SearchBar: Button Cancel Title",
												   bundle: TRIKUtil.trikResourceBundle()!,
												   table: TRIKConstant.FileManagement.FileName.localizedStrings),
		                           for: UIControl.State.normal)
		self.cancelButton.addTarget(self, action: #selector(TRIKSearchBar.cancelButtonTapped(_:)), for: .touchUpInside)
	}
}

// MARK: -
// MARK: Search field control methods
extension TRIKSearchBar {
	/**
	Displays the search bar's cancel button and passes the information about the beginning of an edit to the search bar's delegate.
	
	- parameters:
		- textField: The search bar's search field
	*/
	@objc private func searchFieldDidBeginEditing(_ textField: UITextField) {
		self.showsCancelButton = true
		self.delegate?.searchBarTextDidBeginEditing(self)
	}
	
	/**
	Hides the search bar's cancel button and passes the information about the end of an edit to the search bar's delegate.
	
	- parameters:
		- textField: The search bar's search field
	*/
	@objc private func searchFieldDidEndEditing(_ textField: UITextField) {
		self.showsCancelButton = false
		self.delegate?.searchBarTextDidEndEditing(self)
	}
	
	/**
	Displays or hides the clear button of the search bar's search field subject to whether or not the search field contains text and passes the information about search text changes to the search bar's delegate.
	
	- parameters:
		- textField: The search bar's search field
	*/
	@objc private func searchFieldTextDidChange(_ textField: UITextField) {
		guard let text = self.searchField.text else {
			return
		}
		
		if text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != TRIKConstant.SpecialString.empty {
			self.showsClearButton = true
		}
		else {
			self.showsClearButton = false
		}
		
		self.delegate?.searchBar(self, textDidChange: text)
	}
	
	/**
	Hides the search bar's cancel button and passes the information about the end of an edit to the search bar's delegate.
	
	- parameters:
	- textField: The search bar's search field
	*/
	@objc private func searchFieldDidReturn(_ textField: UITextField) {
		self.delegate?.searchBarSearchButtonClicked(self)
	}
}

// MARK: -
// MARK: Button control methods
extension TRIKSearchBar {
	/**
	Clears the search bar's search field and passes the information about the cancel button tap to the search bar's delegate.
	
	- parameters:
		- sender: The search bar's cancel button
	*/
	@objc private func cancelButtonTapped(_ sender: UIButton) {
		self.showsClearButton = false
		self.searchField.text = TRIKConstant.SpecialString.empty
		self.searchField.resignFirstResponder()
		
		self.delegate?.searchBarCancelButtonClicked(self)
	}
	
	/*
	Clears the search bar's search field and passes the information about the clear button tap to the search bar's delegate.
	
	- parameters:
		- sender: The clear button of the search bar's search field
	*/
	@objc private func clearButtonTapped(_ sender: UIButton) {
		self.searchField.text = TRIKConstant.SpecialString.empty
		self.showsClearButton = false
		
		self.delegate?.searchBar(self, textDidChange: self.searchField.text!)
	}
}
