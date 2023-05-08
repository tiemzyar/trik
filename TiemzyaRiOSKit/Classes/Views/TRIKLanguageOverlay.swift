//
//  TRIKLanguageOverlay.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 09.10.18.
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
View for displaying an overlay to change the language of an application.

Discussion
-
By default, this overlay will use a TRIK framework internal file (TRIKLanguages.plist) for determining available application languages. Currently English and German are supported. If you want to use different or additional languages, simply add the file 'AppLanguages.plist' to your application and structure it like TRIKLanguages.plist.

The structure should look like:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>name</key>
		<string>Deutsch</string>
		<key>code</key>
		<string>de</string>
		<key>available</key>
		<true/>	<!--Language will be available-->
	</dict>
	<dict>
		<key>name</key>
		<string>English</string>
		<key>code</key>
		<string>en</string>
		<key>available</key>
		<false/> <!--Language will not be available-->
	</dict>
</array>
</plist>
```

Note that, when using TRIK framework's method localizedString(forKey:) for localized string retrieval, code also represents the name of the .lproj folder containing the relevant .strings file.

Metadata:
-
Author: tiemzyar

Revision history:
- Created overlay
*/
public class TRIKLanguageOverlay: TRIKOverlay {
	// MARK: Nested types


	// MARK: Type properties
	/// Stores dictionaries for all available application languages (content of TRIKLanguages.plist or a framework external AppLanguages.plist)
	private static var allLanguages: [Dictionary<String, Any>] = {
		var applicationLanguages: [Dictionary<String, Any>] = []
		
		let externalFile = TRIKUtil.Language.checkLanguagesFileValidity(forExternalFile: true)
		if externalFile.valid {
			applicationLanguages = externalFile.content!
		}
		else {
			let internalFile = TRIKUtil.Language.checkLanguagesFileValidity()
			if internalFile.valid {
				applicationLanguages = internalFile.content!
			}
		}
		
		return applicationLanguages
	}()
	
	/// Height of the overlay's cancel button
	private static let buttonHeight: CGFloat = 25.0
	
	/// Default font for the overlay's table section headers
	public static var defaultFontHeader: UIFont = UIFont.boldSystemFont(ofSize: 12.0)
	
	/// Default font for the overlay's title
	public static var defaultFontTitle: UIFont = UIFont.boldSystemFont(ofSize: 15.0)
	
	/// Cell height of the overlay's language table
	private static let tvCellHeight: CGFloat = 40.0
	
	/// Identifier of a reusable language table view cell
	private static let tvCellId = String(describing: TRIKLanguageTVCell.self)
	
	/// Minimum height of the overlay's language table
	private static let tvMinHeight: CGFloat = 150.0
	
	/// Section header height of the overlay's language table
	private static let tvSectionHeaderHeight: CGFloat = 30.0
	
	/// Identifier of a reusable language table view section header
	private static let tvSectionHeaderId = String(describing: TRIKTVSectionHeader.self)
	
	/// Number of sections within the overlay's language table
	private static let tvSections = 2
	

	// MARK: Type methods
	

	// MARK: -
	// MARK: Instance properties
	/// List of available application languages
	private var availableLanguages: [String] = []
	
	/// Triggers a method call of cancelButtonTapped:
	public private (set) var cancelButton: UIButton
	
	/// The overlay's delegate
	public var delegate: TRIKLanguageOverlayDelegate?
	
	/// Stores the ISO 639-1 language code of the overlay's fallback language
	internal private (set) var fallbackLanguage: String
	
	/// Stores the font to use for the content of the overlay's language table
	internal private (set) var fontContent: UIFont
	
	/// Stores the font to use for the section headers of the overlay's language table
	internal private (set) var fontHeader: UIFont
	
	/// Table view for displaying the selected application language as well as all available application languages
	public private (set) var languageTable: UITableView
	
	/// Stores the index path of the last selected table view cell
	private var selectedCell: IndexPath!
	
	/// Currently selected application language
	private var selectedLanguage: String!
	

	// MARK: -
	// MARK: View lifecycle
	public required convenience init?(coder aDecoder: NSCoder) {
		let message = """
			Warning:
			This initializer does not return a working instance of \(String(describing: TRIKLanguageOverlay.self)), but will always return nil.
			Use init(superview:
						text:
						titleFont:
						headerFont:
						contentFont:
						style:
						position:
						fallbackLanguage:
						delegate:)
			instead!
			"""
		devLog(message)
		
		return nil
	}
	
	/**
	The designated initializer of the language overlay.
	
	Initializes the overlay's properties and sets up its layout as well as the layout of its subviews.
	
	- parameters:
		- superview: The overlay's designated superview
		- text: The text to display within the overlay
		- titleFont: The font to use for the overlay's title
		- headerFont: The font to use for the overlay's table headers
		- contentFont: The font to use for the overlay's table content
		- style: The style of the overlay
		- position: The position of the overlay in its superview
		- code: ISO 639-1 language code for the language that should be used as fallback
		- delegate: The overlay's delegate
	
	- returns: A fully set up instance of TRIKLanguageOverlay
	*/
	public init(superview: UIView,
	            text: String,
	            titleFont: UIFont = TRIKLanguageOverlay.defaultFontTitle,
	            headerFont: UIFont = TRIKLanguageOverlay.defaultFontHeader,
	            contentFont: UIFont = TRIKOverlay.defaultFont,
	            style: TRIKOverlay.Style = .white,
	            position: TRIKOverlay.Position = .center,
	            fallbackLanguage code: String = TRIKConstant.Language.Code.english,
				delegate: TRIKLanguageOverlayDelegate? = nil) {
		self.languageTable = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
		self.cancelButton = UIButton(type: UIButton.ButtonType.custom)
		self.delegate = delegate
		self.fontHeader = headerFont
		self.fontContent = contentFont
		self.fallbackLanguage = code
		
		super.init(superview: superview,
		           text: text,
		           font: titleFont,
		           style: style,
		           position: position)
		
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
	Cancels the language change by dismissing the overlay.
	
	- parameters:
		- sender: The overlay's cancel button
	*/
	@objc private func cancelButtonTapped(_ sender: UIButton) {
		self.delegate?.overlayDidCancel(self)
		
		self.dismiss(animated: true) { (_) in
			self.destroy()
		}
	}
	
	/**
	Updates selected language and available languages in the user defaults and passes the confirmation of the language change to the overlay's delegate.
	*/
	private func actionSheetDidDestruct() {
		self.availableLanguages = UserDefaults.standard.array(forKey: TRIKConstant.UserDefaults.availableLanguages) as! [String]
		let index = self.selectedCell.row
		self.selectedLanguage = self.availableLanguages[index]
		self.availableLanguages.remove(at: index)
		self.availableLanguages.append(UserDefaults.standard.string(forKey: TRIKConstant.UserDefaults.selectedLanguage)!)
		self.availableLanguages.sort()
		UserDefaults.standard.set(self.selectedLanguage, forKey: TRIKConstant.UserDefaults.selectedLanguage)
		UserDefaults.standard.set(self.availableLanguages, forKey: TRIKConstant.UserDefaults.availableLanguages)
		
		self.languageTable.reloadData()
		
		var avaLangs: [String] = []
		for dict in TRIKLanguageOverlay.allLanguages {
			if let available = dict[TRIKConstant.PLISTKey.Language.available] as? Bool, available == true {
				if let code = dict[TRIKConstant.PLISTKey.Language.code] as? String {
					if let name = dict[TRIKConstant.PLISTKey.Language.name] as? String, name == self.selectedLanguage {
						avaLangs.insert(code, at: 0)
					}
					else {
						avaLangs.append(code)
					}
				}
			}
		}
		
		UserDefaults.standard.set(avaLangs, forKey: TRIKConstant.UserDefaults.appleLanguages)
		UserDefaults.standard.synchronize()
		
		let userInfo: [String: Any] = [TRIKConstant.Notification.Key.selectedLanguage: self.selectedLanguage!]
		NotificationCenter.default.post(name: TRIKConstant.Notification.Name.languageOverlayDidSelectLanguage,
										object: nil,
										userInfo: userInfo)
		
		self.delegate?.overlay(self, didSelectLanguage: self.selectedLanguage)
	}
	
	/**
	Triggers a call of cancelButtonTapped(_:).
	*/
	private func actionSheetDidCancel() {
		self.languageTable.deselectRow(at: self.selectedCell, animated: true)
		self.cancelButtonTapped(self.cancelButton)
	}
	
}

// MARK: -
// MARK: Setup and customization
extension TRIKLanguageOverlay {
	/**
	Sets up the overlay.
	*/
	private func setupOverlay() {
		self.setupLanguage()
		self.setupSubviewLayout()
		self.customize()
	}
	
	/**
	Sets up the overlay's languages.
	*/
	private func setupLanguage() {
		// Fetch selected language from the user defaults
		if let language = UserDefaults.standard.string(forKey: TRIKConstant.UserDefaults.selectedLanguage) {
			self.selectedLanguage = language
		}
		else {
			// If the user defaults do not contain a selected language, set it subject to the current system language and write it to the user defaults
			var setLanguage = false
			for dict in TRIKLanguageOverlay.allLanguages {
				if let available = dict[TRIKConstant.PLISTKey.Language.available] as? Bool {
					if available {
						if let code = dict[TRIKConstant.PLISTKey.Language.code] as? String {
							if code == TRIKUtil.Language.currentLanguage(withFallback: self.fallbackLanguage).languageCode {
								if let language = dict[TRIKConstant.PLISTKey.Language.name] as? String {
									self.selectedLanguage = language
									setLanguage = true
									break
								}
							}
						}
					}
				}
			}
			
			if !setLanguage {
				self.selectedLanguage = TRIKConstant.Language.name(forCode: self.fallbackLanguage)
			}
			
			UserDefaults.standard.set(self.selectedLanguage, forKey: TRIKConstant.UserDefaults.selectedLanguage)
		}
		
		// Set available languages subject to the selected language and write them to the user defaults
		for dict in TRIKLanguageOverlay.allLanguages {
			if let available = dict[TRIKConstant.PLISTKey.Language.available] as? Bool {
				if available {
					if let language = dict[TRIKConstant.PLISTKey.Language.name] as? String {
						if language != self.selectedLanguage {
							self.availableLanguages.append(language)
						}
					}
				}
			}
		}
		self.availableLanguages.sort()
		
		UserDefaults.standard.set(self.availableLanguages, forKey: TRIKConstant.UserDefaults.availableLanguages)
		UserDefaults.standard.synchronize()
	}
	
	/**
	Sets up the layout of the overlay's subviews.
	*/
	private func setupSubviewLayout() {
		// Adjust label
		if let ctFirstItem = self.labelConstraintAlignmentTop.firstItem {
			self.removeConstraint(self.labelConstraintAlignmentTop)
			self.labelConstraintAlignmentTop = NSLayoutConstraint(item: ctFirstItem,
																  attribute: self.labelConstraintAlignmentTop.firstAttribute,
																  relatedBy: NSLayoutConstraint.Relation.equal,
																  toItem: self.labelConstraintAlignmentTop.secondItem,
																  attribute: self.labelConstraintAlignmentTop.secondAttribute,
																  multiplier: self.labelConstraintAlignmentTop.multiplier,
																  constant: self.labelConstraintAlignmentTop.constant)
			self.addConstraint(self.labelConstraintAlignmentTop)
		}
		
		// Language table
		self.languageTable.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.languageTable)
		let calcHeight = CGFloat(TRIKLanguageOverlay.allLanguages.count) * TRIKLanguageOverlay.tvCellHeight + CGFloat(TRIKLanguageOverlay.tvSections) * TRIKLanguageOverlay.tvSectionHeaderHeight
		let minHeight = max(calcHeight, TRIKLanguageOverlay.tvMinHeight)
		let heightConstraint = NSLayoutConstraint(item: self.languageTable,
												  attribute: NSLayoutConstraint.Attribute.height,
												  relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
												  toItem: nil,
												  attribute: NSLayoutConstraint.Attribute.notAnAttribute,
												  multiplier: 1.0,
												  constant: minHeight)
		heightConstraint.priority = UILayoutPriority(rawValue: 750)
		self.languageTable.addConstraint(heightConstraint)
		self.addConstraint(NSLayoutConstraint(item: self.languageTable,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.leading,
											  multiplier: 1.0,
											  constant: TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.languageTable,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.trailing,
											  multiplier: 1.0,
											  constant: -TRIKOverlay.padding))
		self.addConstraint(NSLayoutConstraint(item: self.languageTable,
											  attribute: NSLayoutConstraint.Attribute.top,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self.label,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  multiplier: 1.0,
											  constant: TRIKOverlay.subviewSpacing))
		
		// Cancel button
		self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.cancelButton)
		self.cancelButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: NSLayoutConstraint.Axis.vertical)
		self.cancelButton.addConstraint(NSLayoutConstraint(item: self.cancelButton,
														   attribute: NSLayoutConstraint.Attribute.height,
														   relatedBy: NSLayoutConstraint.Relation.equal,
														   toItem: nil,
														   attribute: NSLayoutConstraint.Attribute.notAnAttribute,
														   multiplier: 1.0,
														   constant: TRIKLanguageOverlay.buttonHeight))
		self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
											  attribute: NSLayoutConstraint.Attribute.centerX,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self,
											  attribute: NSLayoutConstraint.Attribute.centerX,
											  multiplier: 1.0,
											  constant: 0.0))
		self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
											  attribute: NSLayoutConstraint.Attribute.top,
											  relatedBy: NSLayoutConstraint.Relation.equal,
											  toItem: self.languageTable,
											  attribute: NSLayoutConstraint.Attribute.bottom,
											  multiplier: 1.0,
											  constant: TRIKOverlay.subviewSpacing))
		self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
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
		// Language table
		self.languageTable.layer.cornerRadius = TRIKOverlay.cornerRadius
		self.languageTable.dataSource = self
		self.languageTable.delegate = self
		self.languageTable.separatorStyle = .none
		self.languageTable.backgroundColor = TRIKConstant.Color.clear
		self.languageTable.register(UINib(nibName: String(describing: TRIKLanguageTVCell.self), bundle: TRIKUtil.trikBundle()), forCellReuseIdentifier: TRIKLanguageOverlay.tvCellId)
		self.languageTable.register(UINib(nibName: String(describing: TRIKTVSectionHeader.self), bundle: TRIKUtil.trikBundle()), forCellReuseIdentifier: TRIKLanguageOverlay.tvSectionHeaderId)
		
		// Cancel button
		self.cancelButton.titleLabel!.font = self.fontHeader
		if let bundle = TRIKUtil.trikResourceBundle() {
			let locString = localizedString(forKey: "LangOverlay: Button Cancel",
											bundle: bundle,
											table: TRIKConstant.FileManagement.FileName.localizedStrings)
			self.cancelButton.setTitle(locString, for: UIControl.State.normal)
		}
		let cancel = #selector(TRIKLanguageOverlay.cancelButtonTapped(_:))
		self.cancelButton.addTarget(self, action: cancel, for: UIControl.Event.touchUpInside)
		
		switch (self.style) {
		case .white, .light:
			self.cancelButton.setTitleColor(TRIKConstant.Color.Grey.dark, for:UIControl.State.normal)
			self.cancelButton.setTitleColor(TRIKConstant.Color.black, for:UIControl.State.highlighted)
		case .dark, .black:
			self.cancelButton.setTitleColor(TRIKConstant.Color.Grey.light, for:UIControl.State.normal)
			self.cancelButton.setTitleColor(TRIKConstant.Color.white, for:UIControl.State.highlighted)
		case .tiemzyar:
			self.cancelButton.setTitleColor(TRIKConstant.Color.Blue.light, for:UIControl.State.normal)
			self.cancelButton.setTitleColor(TRIKConstant.Color.Grey.light, for:UIControl.State.highlighted)
		}
	}
}

// MARK: -
// MARK: Table view styling
extension TRIKLanguageOverlay {
	/**
	Styles a cell subject to the overlay's style.
	
	- parameters:
		- cell: The cell to style
		- highlight: Flag about whether or not to style the cell for a highlighted state or not
	*/
	private func styleCell(_ cell: TRIKLanguageTVCell, forHighlighting highlight: Bool) {
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
extension TRIKLanguageOverlay: UITableViewDataSource {
	/**
	Sets the number of sections for the overlay's language table.
	
	- parameters:
		- tableView: Language table
	
	- returns: tvSections
	*/
	public func numberOfSections(in tableView: UITableView) -> Int {
		return TRIKLanguageOverlay.tvSections
	}
	
	/**
	Sets the number of rows in each section for the overlay's language table.
	
	- parameters:
		- tableView: Language table
		- section: Table view section whose number of rows should be set
	
	- returns: 1 for first section, number of available languages otherwise
	*/
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var rows = 0
		switch section {
		case 0:
			rows = 1
		case 1:
			guard let count = UserDefaults.standard.array(forKey: TRIKConstant.UserDefaults.availableLanguages)?.count else {
				return rows
			}
			rows = count
		default:
			break
		}
		
		return rows
	}
	
	/**
	Sets the header height for the overlay's language table.
	
	- parameters:
		- tableView: Language table
		- section: Table view section whose header height should be set
	
	- returns: tvSectionHeaderHeight
	*/
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return TRIKLanguageOverlay.tvSectionHeaderHeight
	}
	
	/**
	Configures the section headers of the overlay's language table.
	
	- parameters:
		- tableView: Language table
		- section: Table view section whose headers should be set
	
	- returns: View for the current section
	*/
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header: TRIKTVSectionHeader = tableView.dequeueReusableCell(withIdentifier: TRIKLanguageOverlay.tvSectionHeaderId) as! TRIKTVSectionHeader
		
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
		
		guard let bundle = TRIKUtil.trikResourceBundle() else {
			return nil
		}
		var locString: String
		switch section {
		case 0:
			locString = localizedString(forKey: "LangOverlay: Table Header Section 0",
										bundle: bundle,
										table: TRIKConstant.FileManagement.FileName.localizedStrings)
		case 1:
			locString = localizedString(forKey: "LangOverlay: Table Header Section 1",
										bundle: bundle,
										table: TRIKConstant.FileManagement.FileName.localizedStrings)
		default:
			locString = TRIKConstant.SpecialString.empty
		}
		header.titleLabel.text = locString
		
		return header
	}
	
	/**
	Sets the cell height for the overlay's language table.
	
	- parameters:
		- tableView: Language table
		- section: Index path for the cell whose height should be set
	
	- returns: tvSectionHeaderHeight
	*/
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TRIKLanguageOverlay.tvCellHeight
	}
	
	/**
	Configures the cells of the overlay's language table subject to indePath.
	
	- parameters:
		- tableView: Language table
		- indexPath: Index path for the current cell
	
	- returns: Cell for the current index path
	*/
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: TRIKLanguageTVCell = tableView.dequeueReusableCell(withIdentifier: TRIKLanguageOverlay.tvCellId, for: indexPath) as! TRIKLanguageTVCell
		
		// Configuring global cell settings
		let selectionColorView = UIView()
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
		cell.isUserInteractionEnabled = false
		
		// Configuring cell specific settings
		switch indexPath.section {
		case 0:
			cell.checkmark.image = UIImage(named: "TRIKCheckmark", in: TRIKUtil.trikResourceBundle(), compatibleWith: nil)
			cell.nameLabel.text = UserDefaults.standard.string(forKey: TRIKConstant.UserDefaults.selectedLanguage)
		case 1:
			cell.isUserInteractionEnabled = true
			cell.checkmark.image = nil
			cell.nameLabel.text = (UserDefaults.standard.array(forKey: TRIKConstant.UserDefaults.availableLanguages) as! [String])[indexPath.row]
		default:
			cell.checkmark.image = nil
			cell.nameLabel.text = TRIKConstant.SpecialString.empty
		}
		
		return cell
	}
}

// MARK: -
// MARK: Table view delegate conformance
extension TRIKLanguageOverlay: UITableViewDelegate {
	/**
	Styles a cell for a highlighted state.
	
	- parameters:
		- tableView: Language table
		- indexPath: Index path for the current cell
	*/
	public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! TRIKLanguageTVCell
		self.styleCell(cell, forHighlighting: true)
	}
	
	/**
	Styles a cell for a normal state.
	
	- parameters:
		- tableView: Language table
		- indexPath: Index path for the current cell
	*/
	public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! TRIKLanguageTVCell
		self.styleCell(cell, forHighlighting: false)
	}
	
	/**
	Triggers an action sheet for language change confirmation.
	
	- parameters:
		- tableView: Language table
		- indexPath: Index path for the current cell
	*/
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath.section == 1) {
			guard let bundle = TRIKUtil.trikResourceBundle() else {
				tableView.deselectRow(at: indexPath, animated: true)
				return
			}
			
			self.selectedCell = indexPath
			let locAlertTitle = localizedString(forKey: "LangOverlay: Actionsheet changeLanguage Title",
												bundle: bundle,
												table: TRIKConstant.FileManagement.FileName.localizedStrings)
			let locButtonTitleDestruct = localizedString(forKey: "LangOverlay: Actionsheet changeLanguage Button Destructive",
														 bundle: bundle,
														 table: TRIKConstant.FileManagement.FileName.localizedStrings)
			let locButtonTitleCancel = localizedString(forKey: "LangOverlay: Actionsheet changeLanguage Button Cancel",
													   bundle: bundle,
													   table: TRIKConstant.FileManagement.FileName.localizedStrings)
			
			let changeLanguage = UIAlertController(title: locAlertTitle,
			                                       message: nil,
			                                       preferredStyle: UIAlertController.Style.actionSheet)
			var action = UIAlertAction(title: locButtonTitleDestruct,
			                           style: UIAlertAction.Style.destructive,
			                           handler: { [weak self] (destructiveAction) in
										self?.actionSheetDidDestruct()
			})
			changeLanguage.addAction(action)
			action = UIAlertAction(title: locButtonTitleCancel,
			                       style: UIAlertAction.Style.cancel,
			                       handler: { [weak self] (cancelAction) in
									self?.actionSheetDidCancel()
			})
			changeLanguage.addAction(action)
			
			if let ppc = changeLanguage.popoverPresentationController {
				let cell = tableView.cellForRow(at: indexPath)!
				ppc.sourceView = cell
				ppc.sourceRect = cell.bounds
				ppc.permittedArrowDirections = .any
			}
			
			changeLanguage.show(animated: true)
		}
	}
}
