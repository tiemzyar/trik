//
//  DBManagerVC.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 12.12.18.
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
import CoreData

// MARK: -
// MARK: Implementation
/**
Controller for showing the usage of the TRIK framework's database manager.
*/
class DBManagerVC: ExampleVC {
	// MARK: Nested types


	// MARK: Type properties
	/// Table view cell prototype id
	fileprivate static let tvCellIdEntry = "Entry Table Cell"
	
	/// Table view cell prototype id
	fileprivate static let tvCellIdHeader = "Entry Table Header"
	
	/// Table view section header height
	fileprivate static let tvHeaderHeight: CGFloat = 30.0

	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties
	/// Description label for the create-entry section of the controller's view
	@IBOutlet weak var createEntryLabel: UILabel!
	
	/// The controller's database manager instance
	lazy var dbManager: TRIKDatabaseManager = TRIKDatabaseManager(databaseDirectory: .library)
	// -> for options see documentation of TRIKDatabaseManager's designated initializer
	
	/// Text field for specifying the title of an entry that should be created
	@IBOutlet weak var entryTF: UITextField!
	
	/// Table listing all stored entries
	@IBOutlet weak var myTable: UITableView!
	
	/// Array containing all stored entries
	var tableEntries: [TableEntry] = []

	// MARK: -
	// MARK: View lifecycle
	/**
	Performs basic example setup
	*/
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.exampleDescriptionLabel.text = localizedString(for: "DBManagerVC: Label Example Desc", fallback: TRIKConstant.Language.Code.german)
		self.createEntryLabel.text = localizedString(for: "DBManagerVC: Label Create Entry", fallback: TRIKConstant.Language.Code.german)
		self.entryTF.placeholder = localizedString(for: "DBManagerVC: Text Field Entry Placeholder", fallback: TRIKConstant.Language.Code.german)
		
		let descriptors = [NSSortDescriptor(keyPath: \TableEntry.creationDate, ascending: true)]
		// Configure the database manager's fetched results controller for a specific entity
		// (using an extension on MZIKDatabaseManager)
        self.dbManager.configureFRC(forEntity: TRIKDatabaseManager.entityNameTableEntry,
									withSortDescriptors: descriptors)
		
		// Fetch entries for the configured entity
		if let entries = self.dbManager.fetchEntries() as? [TableEntry] {
			self.tableEntries = entries
		}
    }

	// MARK: -
	// MARK: Instance methods
	/**
	Triggers the creation of a table entry.
	
	- parameters:
		- sender: The button triggering the method call
	*/
	@IBAction func createButtonTapped(_ sender: UIButton) {
		self.createEntry()
	}
	
	/**
	Creates a table entry and stores it in the application's local database.
	*/
	func createEntry() {
		var entryIsInvalid = false
		if let text = self.entryTF.text {
			if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
				entryIsInvalid = true
			}
		}
		else {
			entryIsInvalid = true
		}
		if entryIsInvalid {
			let locAlertTitle = localizedString(for: "DBManagerVC: Alert invalidEntry Title",
												fallback: TRIKConstant.Language.Code.english)
			let locAlertMessage = localizedString(for: "DBManagerVC: Alert invalidEntry Message",
												  fallback: TRIKConstant.Language.Code.english)
			let locButtonTitleCancel = localizedString(for: "DBManagerVC: Alert invalidEntry Button Cancel",
													   fallback: TRIKConstant.Language.Code.english)
			
			let invalidEntry = UIAlertController(title: locAlertTitle, message: locAlertMessage, preferredStyle: UIAlertControllerStyle.alert)
			let action = UIAlertAction(title: locButtonTitleCancel, style: UIAlertActionStyle.default, handler: nil)
			invalidEntry.addAction(action)
			
			invalidEntry.show(animated: true)
		}
		else {
			// See TRIKDatabaseManager extension in TRIKDatabaseManager+TableEntry.swift on how to store custom entities to an application's local database.
			let result = self.dbManager.createDBEntryForTableEntry(withTitle: self.entryTF.text!)
			if result.created {
				self.entryTF.text = nil
				self.entryTF.resignFirstResponder()
				self.refreshData()
			}
		}
	}
	
	/**
	Fetches entries from the application's local database and reloads the controller's table.
	*/
	func refreshData() {
		if let entries = self.dbManager.fetchEntries() as? [TableEntry] {
			self.tableEntries = entries
			self.myTable.reloadData()
		}
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
// MARK: Text field delegate conformance
extension DBManagerVC {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.createEntry()

		return true
	}
}

// MARK: -
// MARK: Table view data source
extension DBManagerVC: UITableViewDataSource {
	/**
	Sets the number of sections for the controller's table view.

	Parameters:
	- tableView: myTable

	Returns: 1
	*/
 	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	/**
	Sets the number of rows in each section for the controller's table view.

	Parameters:
	- tableView: myTable
	- section: Table view section whose number of rows needs to be set

	Returns: Count of all table entries
	*/
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.tableEntries.count
	}

	/**
	Sets the header height for the controller's table view.
	
	- parameters:
		- tableView: myTable
		- section: Table view section whose header height should be set
	
	- returns: tvHeaderHeight
	*/
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return DBManagerVC.tvHeaderHeight
	}
	
	/**
	Configures the section headers of the controller's table view.
	
	- parameters:
		- tableView: myTable
		- section: Table view section whose header should be set
	
	- returns: View for the current section
	*/
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableCell(withIdentifier: DBManagerVC.tvCellIdHeader)
		
		header?.textLabel?.text = localizedString(for: "DBManagerVC: Table Section Header",
												  fallback: TRIKConstant.Language.Code.german)
		
		return header
	}
	
	/**
	Sets the footer height for the controller's table view.
	
	- parameters:
		- tableView: myTable
		- section: Table view section whose footer height should be set
	
	- returns: tvHeaderHeight
	*/
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return DBManagerVC.tvHeaderHeight
	}
	
	/**
	Configures the section footers of the controller's table view.
	
	- parameters:
		- tableView: myTable
		- section: Table view section whose footer should be set
	
	- returns: View for the current section
	*/
	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footer = tableView.dequeueReusableCell(withIdentifier: DBManagerVC.tvCellIdHeader)
		
		let text: String
		if self.tableEntries.count == 1 {
			text = localizedString(for: "DBManagerVC: Table Section Footer Singular",
								   fallback: TRIKConstant.Language.Code.german)
		}
		else {
			text = localizedString(for: "DBManagerVC: Table Section Footer Plural",
								   fallback: TRIKConstant.Language.Code.german)
		}
		
		footer?.textLabel?.text = "\(self.tableEntries.count) \(text)"
		
		return footer
	}

	/**
	Configures the cells of the controller's table view subject to section and row.

	Parameters:
		- tableView: myTable
		- indexPath: Index path for current section and row

	Returns: Cell for the current index path
	*/
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier:DBManagerVC.tvCellIdEntry) else {
			return UITableViewCell()
		}

		// Global cell configuration
		

		// Cell specific configuration
		let entry = self.tableEntries[indexPath.row]
		let description = localizedString(for: "DBManagerVC: Label Creation Date", fallback: TRIKConstant.Language.Code.german)
		cell.textLabel?.text = entry.title
		if let creationDate = entry.creationDate {
			cell.detailTextLabel?.text = "\(description) \(creationDate)"
		}

	    return cell
	}
}

// MARK: -
// MARK: Table view delegate
extension DBManagerVC: UITableViewDelegate {
	/**
	Sets the table view's editing ability.
	
	- parameters:
		- tableView: myTable
		- indexPath: Index path for current section and row
	
	- returns: true
	*/
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	/**
	Deletes the entry that was selected for deletion from the local database and reloads the table view.
	
	- parameters:
		- tableView: myTable
		- editingStyle: The editing style of the table view
		- indexPath: Index path for current section and row
	*/
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			self.dbManager.deleteObject(self.tableEntries[indexPath.row])
			self.tableEntries.remove(at: indexPath.row)
			tableView.reloadData()
			tableView.isEditing = false
		}
	}
}
