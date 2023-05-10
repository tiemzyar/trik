//
//  TRIKDatabaseManager+TableEntry.swift
//  TiemzyaRiOSKit_Example
//
//  Created by tiemzyar on 13.12.18.
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

import Foundation
import UIKit
import CoreData
import TiemzyaRiOSKit

/**
Extension for enabling the database manager to create and store entries of entity TestEntry (used for unit testing TRIKDatabaseManager).
*/
extension TRIKDatabaseManager {
	// MARK: Nested types
	
	
	// MARK: Type properties
	static let entityNameTestEntry = "TestEntry"
	
	// MARK: Type methods
	
	
	// MARK: -
	// MARK: Instance methods
	/**
	Creates and stores a test entry in the unit test target's local database.
	
	- parameters:
		- title: The test entry's title
	
	- returns: Tuple containing a Bool indicating the success of the entry creation as well as an error, if the creation did fail
	*/
	@discardableResult
	func createDBEntryForTestEntry(withTitle title: String) -> (created: Bool, entry: TestEntry?, error: Error?) {
		var result: (created: Bool, entry: TestEntry?, error: Error?) = (created: false, entry: nil, error: nil)
		
		guard let entity = NSEntityDescription.entity(forEntityName: TRIKDatabaseManager.entityNameTestEntry, in: self.appDBObjectContext) else {
			result.error = DBError(withDescription: "DB entry creation failed",
								   failureReason: "Entity with name '\(TRIKDatabaseManager.entityNameTestEntry)' does not exist")
			return result
		}
		
		guard let entry = NSManagedObject(entity: entity, insertInto: self.appDBObjectContext) as? TestEntry  else {
			result.error = DBError(withDescription: "DB entry creation failed",
								   failureReason: "Class of type '\(TestEntry.self)' does not exist")
			return result
		}
		
		entry.title = title
		entry.creationDate = NSDate()
		entry.identifier = UUID()
		
		do {
			try self.storeChanges()
			result.created = true
			result.entry = entry
		}
		catch {
			result.error = error
		}
		
		return result
	}
}
