//
//  DBManagerTests.swift
//  TiemzyaRiOSKit_UnitTests
//
//  Created by tiemzyar on 30.01.18.
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

import UIKit
import CoreData
import XCTest

@testable import TiemzyaRiOSKit

class DBManagerTests: XCTestCase {
	// MARK: Type properties
	private static let dbName = "CustomDB"
	private static let modelName = "CustomModel"
	private static let testEntityName = "TestEntry"
	
	// MARK: Instance properties
	var count: Int!
	var createdEntries: [NSManagedObject]!
	var dbManager: TRIKDatabaseManager!
	var fetchRequest: NSFetchRequest<NSFetchRequestResult>!
	
	// MARK: Setup and tear-down
	override func setUp() {
		super.setUp()
		
		// Create database manager instance for testing purposes
		self.dbManager = TRIKDatabaseManager(databaseName: DBManagerTests.dbName, dataModelName: DBManagerTests.modelName)
		self.dbManager.testBundle = Bundle(for: type(of: self))
		
		self.createdEntries = []
		self.count = 0
		self.fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DBManagerTests.testEntityName)
	}
	
	override func tearDown() {
		self.dbManager = nil
		self.createdEntries = nil
		self.count = nil
		self.fetchRequest = nil
		
		super.tearDown()
	}
	
	// MARK: Helper methods
	/**
	Creates a url to a persistent store (identically to TRIKDatabaseManager) subject to a passed base url and returns its path.
	
	- parameters:
		- baseURL: The base url of the storage location
	
	- returns: Path of the created url
	*/
	private func getPersistentStorePath(forBaseURL baseURL: URL) -> String {
		var storeURL = baseURL.appendingPathComponent(TRIKConstant.FileManagement.DirectoryName.coreData)
		storeURL = storeURL.appendingPathComponent(self.dbManager.databaseName)
		storeURL = storeURL.appendingPathExtension(TRIKConstant.FileManagement.FileExtension.sqlite)
		
		return storeURL.path
	}
	
	// MARK: Test methods
	func testManagerInitDefault() {
		// Create database manager instance with default values
		self.dbManager = TRIKDatabaseManager()
		self.dbManager.testBundle = Bundle(for: type(of: self))
		
		// Assert instantiation succeeded
		XCTAssertNotNil(self.dbManager.appDBObjectContext.persistentStoreCoordinator, "Persistent store coordinator should not be nil")
		XCTAssertNotNil(self.dbManager.appDBObjectContext.persistentStoreCoordinator?.managedObjectModel, "Managed object model should not be nil")
		
		// Assert default database directory has been selected ('Documents')
		XCTAssertEqual(self.dbManager.databaseDirectory, TRIKDatabaseManager.StorageDirectory.documents, "Database manager's database directory does not match expected directory")
		
		// Assert persistent store has been added to application documents directory
		guard let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
			XCTAssertTrue(false, "No application documents directory found")
			return
		}
		
		XCTAssertTrue(FileManager.default.fileExists(atPath: getPersistentStorePath(forBaseURL: baseURL)),
					  "Persistent store does not exist at expected location")
	}
	
	func testManagerInitWithLibraryDirectory() {
		// Create database manager instance with library as storage directory
		self.dbManager = nil
		self.dbManager = TRIKDatabaseManager(databaseDirectory: .library)
		self.dbManager.testBundle = Bundle(for: type(of: self))
		
		// Assert instantiation succeeded
		XCTAssertNotNil(self.dbManager.appDBObjectContext.persistentStoreCoordinator, "Persistent store coordinator should not be nil")
		XCTAssertNotNil(self.dbManager.appDBObjectContext.persistentStoreCoordinator?.managedObjectModel, "Managed object model should not be nil")
		
		// Assert 'Library' has been selected as database directory
		XCTAssertEqual(self.dbManager.databaseDirectory, TRIKDatabaseManager.StorageDirectory.library, "Database manager's database directory does not match expected directory")
		
		// Assert persistent store has been added to application library directory
		guard let baseURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last else {
			XCTAssertTrue(false, "No application library directory found")
			return
		}
		
		XCTAssertTrue(FileManager.default.fileExists(atPath: getPersistentStorePath(forBaseURL: baseURL)),
					  "Persistent store does not exist at expected location")
	}
	
	func testManagerInitCustomContext() {
		// Create database manager instance with custom context
		self.dbManager = TRIKDatabaseManager()
		self.dbManager.testBundle = Bundle(for: type(of: self))
		let context = self.dbManager.appDBObjectContext
		self.dbManager = TRIKDatabaseManager(managedObjectContext: context)
		
		// Assert instantiation succeeded and context is as expected
		XCTAssertEqual(self.dbManager.appDBObjectContext, context, "Database manager object context does not match expected context")
		XCTAssertNotNil(context.persistentStoreCoordinator, "Persistent store coordinator should not be nil")
		XCTAssertNotNil(context.persistentStoreCoordinator?.managedObjectModel, "Managed object model should not be nil")
	}
	
	func testManagerInitCustomNames() {
		// Assert instantiation succeeded and database as well as data model are named as expected
		XCTAssertEqual(self.dbManager.databaseName, DBManagerTests.dbName, "Database manager's database name does not match expected name")
		XCTAssertEqual(self.dbManager.dataModelName, DBManagerTests.modelName, "Database manager's data model name does not match expected name")
		XCTAssertNotNil(self.dbManager.appDBObjectContext.persistentStoreCoordinator, "Persistent store coordinator should not be nil")
		XCTAssertNotNil(self.dbManager.appDBObjectContext.persistentStoreCoordinator?.managedObjectModel, "Managed object model should not be nil")
	}
	
	func testFRCConfiguration() {
		var descriptors: [NSSortDescriptor] = []
		var result: Bool
		// Configure with empty sort descriptors
		result = self.dbManager.configureFRC(forEntity: DBManagerTests.testEntityName,
											 withSortDescriptors: descriptors)
		// Assert configuration failure
		XCTAssertFalse(result, "FRC configuration should not have been successful")
		
		descriptors = [NSSortDescriptor(keyPath: \TestEntry.creationDate, ascending: true)]
		
		// Configure with invalid entity
		result = self.dbManager.configureFRC(forEntity: "InvalidEntity",
											 withSortDescriptors: descriptors)
		// Assert configuration failure
		XCTAssertFalse(result, "FRC configuration should not have been successful")
		
		// Correct configuration
		result = self.dbManager.configureFRC(forEntity: DBManagerTests.testEntityName,
											 withSortDescriptors: descriptors)
		// Assert configuration success
		XCTAssertNotNil(self.dbManager.appFRC, "FRC should not be nil")
		XCTAssertTrue(result, "FRC configuration should have been successful")
	}
	
	func testFetchingEntries() {
		let descriptors = [NSSortDescriptor(keyPath: \TestEntry.creationDate, ascending: true)]
		self.dbManager.configureFRC(forEntity: DBManagerTests.testEntityName,
									withSortDescriptors: descriptors)
		let entries = self.dbManager.fetchEntries()
		
		// Assert entries have been fetched
		XCTAssertNotNil(entries, "Fetched entries should not be nil")
	}
	
	func testFetchingEntriesNoFRC() {
		let entries = self.dbManager.fetchEntries()
		
		// Assert fetch failed
		XCTAssertNil(entries, "Fetched entries should be nil")
	}
	
	func testSingleObjectDeletion() {
		// Create object and assert its creation
		let result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 1")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		do {
			count = try self.dbManager.appDBObjectContext.count(for: fetchRequest)
		} catch {}
		XCTAssertEqual(count, self.createdEntries.count, "There should be exactly 1 test entry in the database, not \(count!)")
		
		// Delete object and assert its deletion
		guard let entry = result.entry else {
			return
		}
		self.dbManager.deleteObject(entry)
		self.createdEntries = []
		do {
			count = try self.dbManager.appDBObjectContext.count(for: fetchRequest)
		} catch {}
		XCTAssertEqual(count, self.createdEntries.count, "There shouldn't be any test entries in the database")
	}
	
	func testMultipleObjectDeletionByEntity() {
		// Create multiple test entries and delete them all at once, using
		// deleteAllEntriesForEntity(withName:)
		var result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 1")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 2")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 3")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		
		do {
			count = try self.dbManager.appDBObjectContext.count(for: fetchRequest)
		} catch {}
		// Assert creation
		XCTAssertEqual(count , self.createdEntries.count, "There should be exactly 3 test entries in the database, not \(count!)")
		
		do {
			try self.dbManager.deleteAllEntriesForEntity(withName: DBManagerTests.testEntityName)
			self.createdEntries = []
			count = try self.dbManager.appDBObjectContext.count(for: fetchRequest)
		} catch {}
		// Assert deletion
		XCTAssertEqual(count, self.createdEntries.count, "There shouldn't be any test entries in the database")
	}
	
	func testBatchObjectDeletion() {
		// Create multiple test entries and delete them all at once, using
		// batchDeleteAllEntriesForEntity(withName:)
		var result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 1")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 2")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		result = self.dbManager.createDBEntryForTestEntry(withTitle: "New entry 3")
		XCTAssertTrue(result.created, "Entry should have been created")
		if result.created {
			self.createdEntries.append(result.entry!)
		}
		
		do {
			count = try self.dbManager.appDBObjectContext.count(for: fetchRequest)
		} catch {}
		// Assert creation
		XCTAssertEqual(count , self.createdEntries.count, "There should be exactly 3 test entries in the database, not \(count!)")
		
		do {
			try self.dbManager.batchDeleteAllEntriesForEntity(withName: DBManagerTests.testEntityName)
			self.createdEntries = []
			count = try self.dbManager.appDBObjectContext.count(for: fetchRequest)
		} catch {}
		// Assert deletion
		XCTAssertEqual(count, self.createdEntries.count, "There shouldn't be any test entries in the database")
	}
}
