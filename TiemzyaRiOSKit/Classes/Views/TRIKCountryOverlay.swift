//
//  TRIKCountryOverlay.swift
//  TiemzyaRiOSKit
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
import QuartzCore

// MARK: -
// MARK: Implementation
/**
View for displaying an overlay to select a country from a list of countries.

Discussion
-
By default, this overlay will use a TRIK framework internal file (TRIKCountries.plist) for determining available countries. This file contains an ISO-3166-1 compliant list of all countries in the world. If you want to use less countries, simply add the file 'AppCountries.plist' to your application and structure it like TRIKCountries.plist.

The structure should look like:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>code_a2</key>
		<string>AD</string>
		<key>code_a3</key>
		<string>AND</string>
		<key>code_num</key>
		<string>020</string>
		<key>available</key>
		<true/> <!--Country will be available-->
		<key>names</key>
		<dict>
			<key>en</key>
			<string>Andorra</string>
			<key>de</key>
			<string>Andorra</string>
			<key>local</key>
			<string>Andorra</string>
		</dict>
	</dict>
	<dict>
		<key>code_a2</key>
		<string>AE</string>
		<key>code_a3</key>
		<string>ARE</string>
		<key>code_num</key>
		<string>784</string>
		<key>available</key>
		<false/> <!--Country will not be available-->
		<key>names</key>
		<dict>
			<key>en</key>
			<string>United Arab Emirates (the)</string>
			<key>de</key>
			<string>Vereinigte Arabische Emirate</string>
			<key>local</key>
			<string>Al Imārāt</string>
		</dict>
	</dict>
</array>
</plist>
```

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKCountryOverlay: TRIKOverlay {
	// MARK: Nested types
	/**
	Enumeration of selectable locales for the overlay.
	
	Cases:
	- local
	- english
	- german
	*/
	public enum Locale: Int {
		case local = 0
		case english
		case german
	}

	// MARK: Type properties
	/// Stores an array of dictionaries for all countries (content of TRIKCountries.plist or a framework external AppCountries.plist) whose dictionary entry for the key 'available' is true
	private static var availableCountries: [Dictionary<String, Any>] = {
		var allCountries: [Dictionary<String, Any>] = []
		
		let externalFile = TRIKCountryOverlay.checkCountriesFileValidity(forExternalFile: true)
		if externalFile.valid {
			allCountries = externalFile.content!
		}
		else {
			let internalFile = TRIKCountryOverlay.checkCountriesFileValidity()
			if internalFile.valid {
				allCountries = internalFile.content!
			}
		}
		
		var availableCountries : [Dictionary<String, Any>] = []
		for country in allCountries {
			if country[TRIKConstant.PLISTKey.Country.available]! as! Bool == true {
				availableCountries.append(country)
			}
		}
		
		return availableCountries
	}()
	
	/// Default font for the overlay's table section headers
	public static var defaultFontHeader: UIFont = UIFont.boldSystemFont(ofSize: 12.0)
	
	/// Height of the overlay's language switch
	private static let languageSwitchHeight: CGFloat = 30.0
	
	/// Left and right padding of the strings within the language switch's sections
	private static let languageSwitchStringPadding: CGFloat = 5.0
	
	/// Countries file path for testing purposes only
	internal static var testPath: String?
	
	/// Row height of the overlay's country table
	private static let tvCellHeight: CGFloat = 40.0
	
	/// Identifier of a reusable table view cell
	private static let tvCellId = String(describing: TRIKCountryTVCell.self)
	
	/// Minimum height of the overlay's country table
	private static let tvMinHeight: CGFloat = 250.0
	
	/// Minimum width of the overlay's country table
	private static let tvMinWidth: CGFloat = 250.0
	
	/// Section header height of the overlay's country table
	private static let tvSectionHeaderHeight: CGFloat = 25.0
	
	/// Identifier of a reusable table view section header
	private static let tvSectionHeaderId = String(describing: TRIKTVSectionHeader.self)
	
	/// Number of sections within the overlay's country table
	private static let tvSections = 1

	// MARK: Type methods
	/**
	Subject to the parameter external file checks whether the TRIK framework internal countries file or an external countries file is valid.
	
	- parameters:
		- externalFile: Flag about whether to check the TRIK framework internal or an external countries file
	
	- returns: Tuple consisting of a boolean representing the validity state of the checked file and an array containing the file contents, if the file is valid
	*/
	internal static func checkCountriesFileValidity(forExternalFile externalFile: Bool = false) -> (valid: Bool, content: [Dictionary<String, Any>]?) {
		var retValue:(Bool, [Dictionary<String, Any>]?) = (valid: false, content: nil)
		
		var path: String?
		if externalFile {
			if let tPath = TRIKCountryOverlay.testPath {
				guard FileManager.default.fileExists(atPath: tPath) else {
					return retValue
				}
				path = tPath
			}
			else {
				// Guard existence of external countries file
				guard let externalPath = Bundle.main.path(forResource: TRIKConstant.FileManagement.FileName.Countries.external, ofType: TRIKConstant.FileManagement.FileExtension.plist) else {
					return retValue
				}
				path = externalPath
			}
		}
		else {
			// Guard existence of TRIK framework countries file
			guard let internalPath = TRIKUtil.trikResourceBundle()?.path(forResource: TRIKConstant.FileManagement.FileName.Countries.trik, ofType: TRIKConstant.FileManagement.FileExtension.plist) else {
				return retValue
			}
			path = internalPath
		}
		
		// Guard creation of plist data from countries file succeeds
		guard let plistData = FileManager.default.contents(atPath: path!) else {
			return retValue
		}
		
		// Try retrieving plist from plist data
		var format = PropertyListSerialization.PropertyListFormat.xml
		var plist: Any
		do {
			plist = try PropertyListSerialization.propertyList(from: plistData,
			                                                   options: PropertyListSerialization.ReadOptions.mutableContainersAndLeaves,
			                                                   format: &format)
		} catch {
			devLog("Error reading plist: \(error), format: \(format)")
			return retValue
		}
		
		// Guard correct structure of plist
		guard let countries = plist as? [Dictionary<String, Any>] else {
			return retValue
		}
		
		// Guard plist has content
		guard !countries.isEmpty else {
			return retValue
		}
		
		// Check that all language dicts contain correct keys
		for dict in countries {
			if dict[TRIKConstant.PLISTKey.Country.codeA2] as? String == nil ||
				dict[TRIKConstant.PLISTKey.Country.codeA3] as? String == nil ||
				dict[TRIKConstant.PLISTKey.Country.codeNum] as? String == nil ||
				dict[TRIKConstant.PLISTKey.Country.available] as? Bool == nil ||
			dict[TRIKConstant.PLISTKey.Country.names] as? [String: String] == nil {
				return retValue
			}
			else {
				guard let names = dict[TRIKConstant.PLISTKey.Country.names] as? [String: String] else {
					return retValue
				}
				
				guard !names.isEmpty else {
					return retValue
				}
				
				if names[TRIKConstant.PLISTKey.Country.local] == nil ||
					names[TRIKConstant.Language.Code.english] == nil ||
					names[TRIKConstant.Language.Code.german] == nil {
					return retValue
				}
			}
		}
		
		retValue = (valid: true, content: countries)
		
		return retValue
	}

	// MARK: -
	// MARK: Instance properties
	/// Search bar for filtering the list of available countries
	public private (set) var countrySearchBar: TRIKSearchBar
	
	/// Displays an ISO-3166-1 compliant list of selectable countries
	public private (set) var countryTable: UITableView
	
	/// The overlay's delegate, responsible for country selections as well as possible view animations on keyboard appearance respectively disappearance
	public var delegate: TRIKCountryOverlayDelegate?
	
	/// Stores the font to use for the content of the overlay's language table
	internal private (set) var fontContent: UIFont
	
	/// Stores the font to use for the section headers of the overlay's language table
	internal private (set) var fontHeader: UIFont
	
	/// Control for switching the language in which to display the list of countries
	public private (set) var languageSwitch: UISegmentedControl
	
	/// Flag about whether or not localization is enabled or not
	internal private (set) var localizationEnabled: Bool
	
	/// Locale to use within the overlay's country table
	internal private (set) var selectedLocale: Locale
	
	/// Stores an alphabetically sorted version of the available countries
	private var sortedCountries: [Dictionary<String, Any>]!
	
	/// Contains a list of all countries matching the search criteria entered into the coutry search bar
	private var tableData: [Dictionary<String, Any>]!

	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKCountryOverlay.self)), but will always return nil.
			Use init(superview:
						headerFont:
						contentFont:
						style:
						position:
						locale:
						localizationEnabled:
						delegate:)
			instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the country overlay.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- superview: The overlay's designated superview
		- headerFont: The font to use for the overlay's headers
		- contentFont: The font to use for the overlay's content
		- style: The style of the overlay
		- position: The position of the overlay in its superview
		- locale: The initially used locale within the overlay's country table
		- localizationEnabled: Flag about whether or not it should be possible to change the overlay's locale
		- delegate: The overlay's delegate for keyboard animations
	
	- returns: A fully set up instance of TRIKCountryOverlay
	*/
	public init(superview: UIView,
	            headerFont: UIFont = TRIKCountryOverlay.defaultFontHeader,
	            contentFont: UIFont = TRIKOverlay.defaultFont,
	            style: TRIKOverlay.Style = .white,
	            position: TRIKOverlay.Position = .center,
	            locale: TRIKCountryOverlay.Locale = .local,
	            localizationEnabled: Bool = true,
				delegate: TRIKCountryOverlayDelegate? = nil) {
		self.delegate = delegate
		self.fontHeader = headerFont
		self.fontContent = contentFont
		self.selectedLocale = locale
		self.localizationEnabled = localizationEnabled
		
		self.countrySearchBar = TRIKSearchBar(searchFieldHeight: TRIKCountryOverlay.languageSwitchHeight, roundCorners: true)
		self.countryTable = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
		let languages = [localizedString(for: "CSOverlay: Segmented Controle Language Local",
		                                 in: TRIKUtil.trikResourceBundle()!,
										 and: TRIKConstant.FileManagement.FileName.localizedStrings,
										 fallback: TRIKConstant.Language.Code.english),
		                 TRIKConstant.Language.Code.english,
		                 TRIKConstant.Language.Code.german]
		self.languageSwitch = UISegmentedControl(items: languages)
		
		super.init(superview: superview,
		           text: TRIKConstant.SpecialString.empty,
		           font: contentFont,
		           style: style,
		           position: position)
		
		self.sortCountries()
		self.tableData = self.sortedCountries
		
		self.setupOverlay()
	}

	// MARK: Drawing
	/*
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
		// Drawing code
	}
	*/

	// MARK: -
	// MARK: Instance methods
	/**
	Identifies the country name dictionary key subject to the locale selected in the overlay's language switch.
	
	- returns: The dictionary key for the selected locale
	*/
	public func localizedCountryNameKey () -> String {
		let langKey: String
		switch self.selectedLocale {
		case .local:
			langKey = TRIKConstant.PLISTKey.Country.local
		case .english:
			langKey = TRIKConstant.Language.Code.english
		case .german:
			langKey = TRIKConstant.Language.Code.german
		}
		
		return langKey
	}
	
	/**
	Sorts the overlay's list of countries.
	*/
	private func sortCountries() {
		self.sortedCountries = TRIKCountryOverlay.availableCountries.sorted(by: { (countryA, countryB) -> Bool in
			let key = self.localizedCountryNameKey()
			
			let namesA = countryA[TRIKConstant.PLISTKey.Country.names] as! [String: String]
			let namesB = countryB[TRIKConstant.PLISTKey.Country.names] as! [String: String]
			
			return namesA[key]! < namesB[key]!
		})
	}
	
	/**
	Resets the overlay's country table.
	*/
	@objc private func resetTable() {
		if self.localizationEnabled {
			self.selectedLocale = TRIKCountryOverlay.Locale(rawValue: self.languageSwitch.selectedSegmentIndex)!
		}
		self.sortCountries()
		self.tableData = self.sortedCountries
		self.countryTable.reloadData()
		self.countryTable.scrollToRow(at: IndexPath(row: 0, section: 0),
									  at: UITableView.ScrollPosition.top,
									  animated: true)
	}
	
}

// MARK: -
// MARK: Setup and customization
extension TRIKCountryOverlay {
	/**
	Sets up the overlay.
	*/
	private func setupOverlay() {
		setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the layout of the overlay's subviews.
	*/
	private func setupSubviewLayout() {
		// Language switch
		if self.localizationEnabled {
			let dummyLabel = UILabel(frame:CGRect(x: 0.0, y: 0.0, width: 250.0, height: TRIKCountryOverlay.languageSwitchHeight))
			dummyLabel.text = self.languageSwitch.titleForSegment(at: 0)!
			dummyLabel.sizeToFit()
			let languageSwitchWidth = (dummyLabel.frame.size.width + 2 * TRIKCountryOverlay.languageSwitchStringPadding) * CGFloat(self.languageSwitch.numberOfSegments)
			self.languageSwitch.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(self.languageSwitch)
			self.languageSwitch.addConstraint(NSLayoutConstraint(item: self.languageSwitch,
																 attribute: NSLayoutConstraint.Attribute.width,
																 relatedBy: NSLayoutConstraint.Relation.equal,
																 toItem: nil,
																 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
																 multiplier: 1.0,
																 constant: languageSwitchWidth))
			self.languageSwitch.addConstraint(NSLayoutConstraint(item: self.languageSwitch,
																 attribute: NSLayoutConstraint.Attribute.height,
																 relatedBy: NSLayoutConstraint.Relation.equal,
																 toItem: nil,
																 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
																 multiplier: 1.0,
																 constant: TRIKCountryOverlay.languageSwitchHeight))
			self.addConstraint(NSLayoutConstraint(item: self.languageSwitch,
												  attribute: NSLayoutConstraint.Attribute.top,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.top,
												  multiplier: 1.0,
												  constant: TRIKOverlay.padding))
			self.addConstraint(NSLayoutConstraint(item: self.languageSwitch,
												  attribute: NSLayoutConstraint.Attribute.leading,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.leading,
												  multiplier: 1.0,
												  constant: TRIKOverlay.padding))
			self.addConstraint(NSLayoutConstraint(item: self.languageSwitch,
												  attribute: NSLayoutConstraint.Attribute.trailing,
												  relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.trailing,
												  multiplier: 1.0,
												  constant: -TRIKOverlay.padding))
		}
		
		// Search bar
		self.countrySearchBar.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.countrySearchBar)
		if self.localizationEnabled {
			self.addConstraint(NSLayoutConstraint(item: self.languageSwitch,
												  attribute: NSLayoutConstraint.Attribute.bottom,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self.countrySearchBar,
												  attribute: NSLayoutConstraint.Attribute.top,
												  multiplier: 1.0,
												  constant: -TRIKOverlay.subviewSpacing))
		}
		else {
			self.addConstraint(NSLayoutConstraint(item: self.countrySearchBar,
												  attribute: NSLayoutConstraint.Attribute.top,
												  relatedBy: NSLayoutConstraint.Relation.equal,
												  toItem: self,
												  attribute: NSLayoutConstraint.Attribute.top,
												  multiplier: 1.0,
												  constant: TRIKOverlay.padding))
		}
		
		// Country table
		self.countryTable.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.countryTable)
		let heightConstraint = NSLayoutConstraint(item: self.countryTable,
												  attribute: NSLayoutConstraint.Attribute.height,
												  relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
												  toItem: nil,
												  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
												  multiplier: 1.0,
												  constant: TRIKCountryOverlay.tvMinHeight)
		heightConstraint.priority = UILayoutPriority(rawValue: 750)
		self.countryTable.addConstraint(heightConstraint)
		let widthConstraint = NSLayoutConstraint(item: self.countryTable,
												 attribute: NSLayoutConstraint.Attribute.width,
												 relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
												 toItem: nil,
												 attribute: NSLayoutConstraint.Attribute.notAnAttribute,
												 multiplier: 1.0,
												 constant: TRIKCountryOverlay.tvMinWidth)
		widthConstraint.priority = UILayoutPriority(rawValue: 750)
		self.countryTable.addConstraint(widthConstraint)
		self.addConstraint(NSLayoutConstraint(item: self.countrySearchBar,
											  attribute: NSLayoutConstraint.Attribute.width,
											  relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
											  toItem: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.width,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.countrySearchBar,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.countrySearchBar,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.countrySearchBar,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.top,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.subviewSpacing))
		self.addConstraint(NSLayoutConstraint(item: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.countryTable,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
	}
	
	/**
	Customizes the overlay's subviews.
	*/
	private func customize() {
		self.customizeLanguageSwitch()
		self.customizeSearchBar()
		self.customizeCountryTable()
	}
	
	/**
	Customizes the overlay's language switch.
	*/
	private func customizeLanguageSwitch() {
		if self.localizationEnabled {
			self.languageSwitch.layer.cornerRadius = TRIKOverlay.cornerRadius
			self.languageSwitch.layer.borderWidth = 1.0
			self.languageSwitch.layer.masksToBounds = true
			var attributes: [String: Any] = [NSAttributedString.Key.font.rawValue: self.fontContent]
			var selectedAttributes: [String: Any] = [:]
			switch self.style {
			case .white:
				attributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.black
				selectedAttributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Grey.light
				self.languageSwitch.backgroundColor = TRIKConstant.Color.white
				self.languageSwitch.tintColor = TRIKConstant.Color.Grey.dark
				self.languageSwitch.layer.borderColor = self.languageSwitch.tintColor.cgColor
			case .light:
				attributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Grey.dark
				selectedAttributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Grey.light
				self.languageSwitch.backgroundColor = TRIKConstant.Color.Grey.light
				self.languageSwitch.tintColor = TRIKConstant.Color.Grey.dark
				self.languageSwitch.layer.borderColor = self.languageSwitch.tintColor.cgColor
			case .dark:
				attributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Grey.light
				selectedAttributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Grey.dark
				self.languageSwitch.backgroundColor = TRIKConstant.Color.Grey.dark
				self.languageSwitch.tintColor = TRIKConstant.Color.Grey.light
				self.languageSwitch.layer.borderColor = self.languageSwitch.tintColor.cgColor
			case .black:
				attributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.white
				selectedAttributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Grey.dark
				self.languageSwitch.backgroundColor = TRIKConstant.Color.black
				self.languageSwitch.tintColor = TRIKConstant.Color.Grey.light
				self.languageSwitch.layer.borderColor = self.languageSwitch.tintColor.cgColor
			case .tiemzyar:
				attributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.Blue.tiemzyar
				selectedAttributes[NSAttributedString.Key.foregroundColor.rawValue] = TRIKConstant.Color.white
				self.languageSwitch.backgroundColor = TRIKConstant.Color.white
				self.languageSwitch.tintColor = TRIKConstant.Color.Blue.tiemzyar
				self.languageSwitch.layer.borderColor = self.languageSwitch.tintColor.cgColor
			}
			self.languageSwitch.setTitleTextAttributes(attributes, for: .normal)
			self.languageSwitch.setTitleTextAttributes(selectedAttributes, for: .selected)
			self.languageSwitch.selectedSegmentIndex = self.selectedLocale.rawValue
			let resetTable = #selector(TRIKCountryOverlay.resetTable)
			self.languageSwitch.addTarget(self, action: resetTable, for: UIControl.Event.valueChanged)
		}
	}
	
	/**
	Customizes the overlay's search bar.
	*/
	private func customizeSearchBar() {
		self.countrySearchBar.delegate = self
		self.countrySearchBar.searchField.autocorrectionType = .no
		self.countrySearchBar.searchField.autocapitalizationType = .none
		self.countrySearchBar.searchField.spellCheckingType = .no
		self.countrySearchBar.searchField.keyboardType = .asciiCapable
		self.countrySearchBar.searchField.returnKeyType = .search
		self.countrySearchBar.searchField.font = self.fontContent
		let placeholderText = NSMutableAttributedString(string: localizedString(for: "CSOverlay: Search Bar Placeholder",
																				in: TRIKUtil.trikResourceBundle()!,
																				and: TRIKConstant.FileManagement.FileName.localizedStrings,
																				fallback: TRIKConstant.Language.Code.english),
														attributes: [NSAttributedString.Key.font: self.fontContent])
		
		// Search bar elements
		self.countrySearchBar.cancelButton.titleLabel?.font = self.fontHeader
		
		switch self.style {
		case .white:
			self.countrySearchBar.backgroundColor = TRIKConstant.Color.white
			self.countrySearchBar.searchField.textColor = TRIKConstant.Color.black
			placeholderText.addAttributes([NSAttributedString.Key.foregroundColor: TRIKConstant.Color.Grey.dark], range: NSMakeRange(0, placeholderText.length))
			
			self.countrySearchBar.searchIcon?.image = self.countrySearchBar.searchIcon?.image?.withRenderingMode(.alwaysTemplate)
			self.countrySearchBar.searchIcon?.tintColor = TRIKConstant.Color.black
			
			self.countrySearchBar.clearButton?.setBackgroundImage(self.countrySearchBar.clearButton?.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
			self.countrySearchBar.clearButton?.tintColor = TRIKConstant.Color.Grey.dark
			
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.Grey.dark, for: .normal)
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.black, for: .highlighted)
		case .light:
			self.countrySearchBar.backgroundColor = TRIKConstant.Color.Grey.light
			self.countrySearchBar.searchField.textColor = TRIKConstant.Color.Grey.dark
			placeholderText.addAttributes([NSAttributedString.Key.foregroundColor: TRIKConstant.Color.Grey.medium], range: NSMakeRange(0, placeholderText.length))
			
			self.countrySearchBar.searchIcon?.image = self.countrySearchBar.searchIcon?.image?.withRenderingMode(.alwaysTemplate)
			self.countrySearchBar.searchIcon?.tintColor = TRIKConstant.Color.Grey.dark
			
			self.countrySearchBar.clearButton?.setBackgroundImage(self.countrySearchBar.clearButton?.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
			self.countrySearchBar.clearButton?.tintColor = TRIKConstant.Color.Grey.dark
			
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.Grey.dark, for: .normal)
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.black, for: .highlighted)
		case .dark:
			self.countrySearchBar.backgroundColor = TRIKConstant.Color.Grey.dark
			self.countrySearchBar.searchField.textColor = TRIKConstant.Color.Grey.light
			placeholderText.addAttributes([NSAttributedString.Key.foregroundColor: TRIKConstant.Color.Grey.medium], range: NSMakeRange(0, placeholderText.length))
			
			self.countrySearchBar.searchIcon?.image = self.countrySearchBar.searchIcon?.image?.withRenderingMode(.alwaysTemplate)
			self.countrySearchBar.searchIcon?.tintColor = TRIKConstant.Color.Grey.light
			
			self.countrySearchBar.clearButton?.setBackgroundImage(self.countrySearchBar.clearButton?.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
			self.countrySearchBar.clearButton?.tintColor = TRIKConstant.Color.Grey.light
			
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.Grey.light, for: .normal)
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.white, for: .highlighted)
		case .black:
			self.countrySearchBar.backgroundColor = TRIKConstant.Color.black
			self.countrySearchBar.searchField.textColor = TRIKConstant.Color.white
			placeholderText.addAttributes([NSAttributedString.Key.foregroundColor: TRIKConstant.Color.Grey.dark], range: NSMakeRange(0, placeholderText.length))
			
			self.countrySearchBar.searchIcon?.image = self.countrySearchBar.searchIcon?.image?.withRenderingMode(.alwaysTemplate)
			self.countrySearchBar.searchIcon?.tintColor = TRIKConstant.Color.Grey.dark
			
			self.countrySearchBar.clearButton?.setBackgroundImage(self.countrySearchBar.clearButton?.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
			self.countrySearchBar.clearButton?.tintColor = TRIKConstant.Color.Grey.light
			
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.Grey.light, for: .normal)
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.white, for: .highlighted)
		case .tiemzyar:
			self.countrySearchBar.backgroundColor = TRIKConstant.Color.white
			self.countrySearchBar.searchField.textColor = TRIKConstant.Color.Blue.tiemzyar
			placeholderText.addAttributes([NSAttributedString.Key.foregroundColor: TRIKConstant.Color.Grey.dark],
										  range: NSMakeRange(0, placeholderText.length))
			
			self.countrySearchBar.searchIcon?.image = self.countrySearchBar.searchIcon?.image?.withRenderingMode(.alwaysTemplate)
			self.countrySearchBar.searchIcon?.tintColor = TRIKConstant.Color.Blue.tiemzyar
			
			self.countrySearchBar.clearButton?.setBackgroundImage(self.countrySearchBar.clearButton?.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
			self.countrySearchBar.clearButton?.tintColor = TRIKConstant.Color.Blue.light
			
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.Blue.light, for: .normal)
			self.countrySearchBar.cancelButton.setTitleColor(TRIKConstant.Color.Blue.tiemzyar, for: .highlighted)
		}
		
		self.countrySearchBar.searchField.attributedPlaceholder = placeholderText
	}
	
	/**
	Customizes the overlay's country table.
	*/
	private func customizeCountryTable() {
		self.countryTable.layer.cornerRadius = TRIKOverlay.cornerRadius
		self.countryTable.dataSource = self
		self.countryTable.delegate = self
		self.countryTable.backgroundColor = TRIKConstant.Color.clear
		self.countryTable.separatorStyle = .none
		self.countryTable.register(UINib(nibName: String(describing: TRIKCountryTVCell.self),
										 bundle: TRIKUtil.trikBundle()),
								   forCellReuseIdentifier: TRIKCountryOverlay.tvCellId)
		self.countryTable.register(UINib(nibName: String(describing: TRIKTVSectionHeader.self),
										 bundle: TRIKUtil.trikBundle()),
								   forCellReuseIdentifier: TRIKCountryOverlay.tvSectionHeaderId)
		self.countryTable.showsHorizontalScrollIndicator = false
		self.countryTable.showsVerticalScrollIndicator = true
		self.countryTable.isScrollEnabled = true
		self.countryTable.isPagingEnabled = false
		self.countryTable.bounces = true
		self.countryTable.alwaysBounceHorizontal = false
		self.countryTable.alwaysBounceVertical = true
	}
}


// MARK: -
// MARK: Search bar delegate conformance
extension TRIKCountryOverlay: TRIKSearchBarDelegate {
	/**
	Sets the overlay's country search bar as active view for view animations.
	
	- parameters:
		- searchBar: The overlay's country search bar
	*/
	public func searchBarTextDidBeginEditing(_ searchBar: TRIKSearchBar) {
		searchBar.showsCancelButton = true
		self.delegate?.activeView = searchBar
	}
	
	/**
	Removes the overlay's country search bar as actice view for view animations.
	
	- parameters:
		- searchBar: The overlay's country search bar
	*/
	public func searchBarTextDidEndEditing(_ searchBar: TRIKSearchBar) {
		searchBar.showsCancelButton = false
		self.delegate?.activeView = nil
	}
	
	/**
	Shows all available countries in the property @ref countryTable if the parameter searchText is empty.
	
	Shows only countries containing searchText otherwise.
	
	- parameters:
		- searchBar: The overlay's country search bar
		- searchText: The text entered into the overlay's country search bar
	*/
	public func searchBar(_ searchBar: TRIKSearchBar, textDidChange searchText: String) {
		self.tableData.removeAll()
		
		// Show all possible countries in the country selection table if searchText is empty
		if searchText == TRIKConstant.SpecialString.empty {
			self.tableData.append(contentsOf: self.sortedCountries)
			self.countryTable.reloadData()
		}
		else {
			for dict in self.sortedCountries {
				let names = dict[TRIKConstant.PLISTKey.Country.names] as! [String: String]
				let countryName = names[self.localizedCountryNameKey()]!
				if countryName.range(of: searchText,
									 options: String.CompareOptions.caseInsensitive,
									 range: nil,
									 locale: nil) != nil {
					self.tableData.append(dict)
				}
			}
		}
		
		self.countryTable.reloadData()
	}
	
	/**
	Resets the overlay's country table.
	
	- parameters:
		- searchBar: The overlay's country search bar
	*/
	public func searchBarCancelButtonClicked(_ searchBar: TRIKSearchBar) {
		self.resetTable()
	}
	
	/**
	Resigns the search bar as first responder.
	
	- parameters:
		- searchBar: The overlay's country search bar
	*/
	public func searchBarSearchButtonClicked(_ searchBar: TRIKSearchBar) {
		searchBar.resignFirstResponder()
	}
}

// MARK: -
// MARK: Table view styling
extension TRIKCountryOverlay {
	/**
	Styles a cell subject to the overlay's style.
	
	- parameters:
		- cell: The cell to style
		- highlight: Flag about whether or not to style the cell for a highlighted state or not
	*/
	private func styleCell(_ cell: TRIKCountryTVCell, forHighlighting highlight: Bool) {
		if highlight {
			cell.backgroundColor = TRIKConstant.Color.clear
			switch self.style {
			case .white:
				cell.nameLabel.textColor = TRIKConstant.Color.Grey.light
			case .light:
				cell.nameLabel.textColor = TRIKConstant.Color.Grey.light
			case .dark:
				cell.nameLabel.textColor = TRIKConstant.Color.Grey.dark
			case .black:
				cell.nameLabel.textColor = TRIKConstant.Color.Grey.dark
			case .tiemzyar:
				cell.nameLabel.textColor = TRIKConstant.Color.white
			}
		}
		else {
			switch self.style {
			case .white:
				cell.nameLabel.textColor = TRIKConstant.Color.black
				cell.backgroundColor = TRIKConstant.Color.white
			case .light:
				cell.nameLabel.textColor = TRIKConstant.Color.Grey.dark
				cell.backgroundColor = TRIKConstant.Color.Grey.light
			case .dark:
				cell.nameLabel.textColor = TRIKConstant.Color.Grey.light
				cell.backgroundColor = TRIKConstant.Color.Grey.dark
			case .black:
				cell.nameLabel.textColor = TRIKConstant.Color.white
				cell.backgroundColor = TRIKConstant.Color.black
			case .tiemzyar:
				cell.nameLabel.textColor = TRIKConstant.Color.Blue.tiemzyar
				cell.backgroundColor = TRIKConstant.Color.white
			}
		}
	}
}

// MARK: -
// MARK: Table view data source conformance
extension TRIKCountryOverlay: UITableViewDataSource {
	/**
	Sets the number of sections for the table view.
	
	- parameters:
		- tableView: Country table
	
	- returns: tvSections
	*/
	public func numberOfSections(in tableView: UITableView) -> Int {
		return TRIKCountryOverlay.tvSections
	}
	
	/**
	Sets the number of rows for the table view subject to the property tableData.
	
	- parameters:
		- tableView: Country table
		- section: Table view section whose number of rows should be set
	
	- returns: Count of all countries matching optional search parameters
	*/
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.tableData.count
	}
	
	/**
	Sets the header height for the overlay's country table.
	
	- parameters:
		- tableView: Country table
		- section: Table view section whose header height should be set
	
	- returns: tvSectionHeaderHeight
	*/
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return TRIKCountryOverlay.tvSectionHeaderHeight
	}
	
	/**
	Configures the section headers of the overlay's country table.
	
	- parameters:
		- tableView: Country table
		- section: Table view section whose header should be set
	
	- returns: View for the current section
	*/
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableCell(withIdentifier: TRIKCountryOverlay.tvSectionHeaderId) as! TRIKTVSectionHeader
		
		switch self.style {
		case .white:
			header.backgroundColor = TRIKConstant.Color.Grey.light
			header.titleLabel.textColor = TRIKConstant.Color.Grey.dark
		case .light:
			header.backgroundColor = TRIKConstant.Color.white
			header.titleLabel.textColor = TRIKConstant.Color.black
		case .dark:
			header.backgroundColor = TRIKConstant.Color.black
			header.titleLabel.textColor = TRIKConstant.Color.white
		case .black:
			header.backgroundColor = TRIKConstant.Color.Grey.dark
			header.titleLabel.textColor = TRIKConstant.Color.Grey.light
		case .tiemzyar:
			header.backgroundColor = TRIKConstant.Color.Blue.light
			header.titleLabel.textColor = TRIKConstant.Color.white
		}

		header.titleLabel.text = localizedString(for: "CSOverlay: Table Section Header",
												 in: TRIKUtil.trikResourceBundle()!,
												 and: TRIKConstant.FileManagement.FileName.localizedStrings,
												 fallback: TRIKConstant.Language.Code.english)
		
		return header
	}
	
	/**
	Sets the cell height for the overlay's country table.
	
	- parameters:
		- tableView: Country table
		- section: Index path for the cell whose height should be set
	
	- returns: tvCellHeight
	*/
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TRIKCountryOverlay.tvCellHeight
	}
	
	/**
	Configures the cells of the overlay's country table subject to section and row.
	
	- parameters:
		- tableView: Country table
		- indexPath: Index path for the current cell
	
	- returns: Cell for the current index path
	*/
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TRIKCountryOverlay.tvCellId, for: indexPath) as! TRIKCountryTVCell
		
		// Configuring global cell settings
		let selectionColorView = UIView(frame: CGRect.zero)
		selectionColorView.backgroundColor = TRIKConstant.Color.Blue.tiemzyar
		switch self.style {
		case .white:
			selectionColorView.backgroundColor = TRIKConstant.Color.Grey.dark
		case .light:
			selectionColorView.backgroundColor = TRIKConstant.Color.Grey.dark
		case .dark:
			selectionColorView.backgroundColor = TRIKConstant.Color.Grey.light
		case .black:
			selectionColorView.backgroundColor = TRIKConstant.Color.Grey.light
		case .tiemzyar:
			selectionColorView.backgroundColor = TRIKConstant.Color.Blue.tiemzyar
		}
		cell.selectedBackgroundView = selectionColorView
		self.styleCell(cell, forHighlighting: false)
		cell.nameLabel.font = self.fontContent
		cell.nameLabel.textAlignment = .left
		cell.nameLabel.numberOfLines = 2
		
		// Configuring cell specific settings
		let currentCountry = self.tableData[indexPath.row]
		let names = currentCountry[TRIKConstant.PLISTKey.Country.names] as! [String: String]
		cell.nameLabel.text = names[self.localizedCountryNameKey()]!
		cell.isoAlpha2Code = (currentCountry[TRIKConstant.PLISTKey.Country.codeA2] as! String)
		cell.isoAlpha3Code = (currentCountry[TRIKConstant.PLISTKey.Country.codeA3] as! String)
		cell.isoNumericCode = (currentCountry[TRIKConstant.PLISTKey.Country.codeNum] as! String)
		
		return cell
	}
}

// MARK: -
// MARK: Table view delegate conformance
extension TRIKCountryOverlay: UITableViewDelegate {
	/**
	Styles a cell for a highlighted state.
	
	- parameters:
		- tableView: Country table
		- indexPath: Index path for the current cell
	*/
	public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! TRIKCountryTVCell
		self.styleCell(cell, forHighlighting: true)
	}
	
	/**
	Styles a cell for a normal state.
	
	- parameters:
		- tableView: Country table
		- indexPath: Index path for the current cell
	*/
	public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! TRIKCountryTVCell
		self.styleCell(cell, forHighlighting: false)
	}
	
	/**
	Posts a notification about the selection of a row.
	
	- parameters:
		- tableView: Country table
		- indexPath: Index path for the current cell
	*/
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let countryDict = self.tableData[indexPath.row]
		
		guard let names = countryDict[TRIKConstant.PLISTKey.Country.names] as? [String: String],
			let codeA2 = countryDict[TRIKConstant.PLISTKey.Country.codeA2] as? String,
			let codeA3 = countryDict[TRIKConstant.PLISTKey.Country.codeA3] as? String,
			let codeNum = countryDict[TRIKConstant.PLISTKey.Country.codeNum] as? String else {
				return
		}
		
		let country = (names: names, codeA2: codeA2, codeA3: codeA3, codeNum: codeNum)
		self.delegate?.countryOverlay(self, didSelectCountry: country)
	}
}
