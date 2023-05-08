//
//  TRIKDatabaseManager.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 12.12.18.
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
import CoreData

// MARK: -
// MARK: Implementation
/**
Class for simplifying the creation of and interaction with a CoreData database within an application.
*/
public class TRIKDatabaseManager: NSObject {
	// MARK: Nested types
	/**
	Enumeration of possible storage directories for the database manager's persistent store.
	
	Cases:
	- library (persistent store gets added to a subdirectory of the application library directory)
	- documents (persistent store gets added to a subdirectory of the application documents directory)
	*/
	public enum StorageDirectory: Int {
		case library = 0
		case documents
	}

	// MARK: -
	// MARK: Instance properties
	/// The database manager's main managed object context, which operates on the main queue
	public lazy var appDBObjectContext: NSManagedObjectContext = { [unowned self] in
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.persistentStoreCoordinator = self.appDBStoreCoordinator
		context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
		
		return context
	}()
	
	/// The database manager's background managed object context, which is a child of ``appDBObjectContext``
	public lazy var backgroundChildContext: NSManagedObjectContext = { [unowned self] in
		return self.createPrivateBackgroundContext()
	}()
	
	/// The database manager's managed object model
	private lazy var appDBObjectModel: NSManagedObjectModel? = { [unowned self] in
		var bundle: Bundle
		if let testBundle = self.testBundle {
			bundle = testBundle
		}
		else {
			bundle = Bundle.main
		}
		guard let modelURL = bundle.url(forResource: self.dataModelName,
											 withExtension: TRIKConstant.FileManagement.FileExtension.momd) else {
			return nil
		}
		
		return NSManagedObjectModel(contentsOf: modelURL)
	}()
	
	/// The database manager's persistent store coordinator
	private (set) lazy var appDBStoreCoordinator: NSPersistentStoreCoordinator? = { [unowned self] in
		var storageDirectoryURL: URL? = nil
		if self.databaseDirectory == TRIKDatabaseManager.StorageDirectory.documents {
			storageDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
		}
		else {
			storageDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last
		}
		
		guard let baseURL = storageDirectoryURL else {
			return nil
		}
		
		let coreDataDirectoryURL = baseURL.appendingPathComponent(TRIKConstant.FileManagement.DirectoryName.coreData)
		if !FileManager.default.fileExists(atPath: coreDataDirectoryURL.path) {
			do {
				try FileManager.default.createDirectory(at: coreDataDirectoryURL, withIntermediateDirectories: true, attributes: nil)
			}
			catch {
				devLog("Database directory creation failed with error: \(error)")
				return nil
			}
		}
		
		var storeURL = coreDataDirectoryURL.appendingPathComponent(self.databaseName)
		storeURL = storeURL.appendingPathExtension(TRIKConstant.FileManagement.FileExtension.sqlite)
		
		let options = [NSMigratePersistentStoresAutomaticallyOption: true,
					   NSInferMappingModelAutomaticallyOption: true]
		
		guard let model = self.appDBObjectModel else {
			return nil
		}
		
		var coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		do {
			try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
											   configurationName: nil,
											   at: storeURL,
											   options: options)
		}
		catch {
			devLog("Adding of persistent store failed with error: \(error)")
			return nil
		}
		
		return coordinator
	}()
	
	/// The database manager's fetched results controller
	public var appFRC: NSFetchedResultsController<NSFetchRequestResult>?
	
	/// Stores the name of the database that is used by the database manager
	public private (set) var databaseName: String
	
	/// Stores the directory to which the database manager's persistent store should be added
	public private (set) var databaseDirectory: TRIKDatabaseManager.StorageDirectory
	
	/// Stores the name of the data model that is used by the database manager
	public private (set) var dataModelName: String
	
	/// Bundle solely for testing purposes
	internal var testBundle: Bundle?

	// MARK: -
	// MARK: Class lifecycle
	/**
	The designated initializer of the database manager.
	
	Initializes the manager's properties and sets up its managed object context.
	
	Discussion
	-
	If no context is passed on initialization, the database manager will create its own managed object context (of type .mainQueueConcurrencyType), using the parameter dbName for creating its persistent store coordinator (psc) and the parameter modelName for the psc's managed object model.
	
	Subject to the parameter dbDirectory the peristent store will then be created within the application documents or
	library directory, subdirectory TRIKConstant.FileManagement.DirectoryName.coreData.
	
	If a custom context is passed, the parameters dbName and modelName will be ignored.
	
	- parameters:
		- dbDirectory: Storage directory for the database
					(default = TRIKDatabaseManager.StorageDirectory.documents)
		- dbName: Name of the database to use
					(default = TRIKConstant.FileManagement.FileName.CoreData.databaseDefault)
		- modelName: Name of the data model to use
						(default = TRIKConstant.FileManagement.FileName.CoreData.modelDefault)
		- context: The managed object context to use
					(default = nil)
	
	- returns: A fully set up instance of TRIKDatabaseManager
	*/
	public init(databaseDirectory dbDirectory: TRIKDatabaseManager.StorageDirectory = TRIKDatabaseManager.StorageDirectory.documents,
				databaseName dbName: String = TRIKConstant.FileManagement.FileName.CoreData.databaseDefault,
				dataModelName modelName: String = TRIKConstant.FileManagement.FileName.CoreData.modelDefault,
				managedObjectContext context: NSManagedObjectContext? = nil) {
		// Trim possible file extensions from database name
		let trimmedDBName = dbName.replacingOccurrences(of: ".\(TRIKConstant.FileManagement.FileExtension.sqlite)", with: "")
		
		// Trim possible file extensions from data model name
		var trimmedModelName = modelName.replacingOccurrences(of: ".\(TRIKConstant.FileManagement.FileExtension.momd)", with: "")
		trimmedModelName = modelName.replacingOccurrences(of: ".\(TRIKConstant.FileManagement.FileExtension.xcDataModel)", with: "")
		trimmedModelName = modelName.replacingOccurrences(of: ".\(TRIKConstant.FileManagement.FileExtension.xcDataModelD)", with: "")
		
		self.databaseDirectory = dbDirectory
		self.databaseName = trimmedDBName
		self.dataModelName = trimmedModelName
		
		super.init()
		
		if let ctx = context {
			self.appDBObjectContext = ctx
			self.appDBStoreCoordinator = self.appDBObjectContext.persistentStoreCoordinator
			self.appDBObjectModel = self.appDBStoreCoordinator?.managedObjectModel
		}
	}
	
	/**
	Creates a managed object context, which operates on a private background queue, and has the database manager's main context as parent.
	
	- returns: Created context
	*/
	private func createPrivateBackgroundContext() -> NSManagedObjectContext {
		let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		moc.parent = self.appDBObjectContext
		moc.automaticallyMergesChangesFromParent = true
		
		return moc
	}
	
	// MARK: -
	// MARK: Instance methods
	/**
	Configures the database managers fetched results controller with a fetch request for a given entity.
	
	- parameters:
		- entityName: Name of the entity used for fetch request configuration
		- sortDescriptors: Sort descriptors for fetch request configuration
		- predicate: Predicate for fetch request configuration
						(default = nil)
		- fetchLimit: Limit for results to fetch
					(default = 0)
		- context: Managed object context to use for fetches
						(default = nil --> uses the database manager's default context)
		- keyPath: Key path to use for fetches
					(default = nil)
		- cache: Cache to use for fetches
					(default = "Root")
	*/
	@discardableResult public func configureFRC(forEntity entityName: String,
												withSortDescriptors sortDescriptors: [NSSortDescriptor],
												predicate: NSPredicate? = nil,
												fetchLimit: Int = 0,
												usingContext context: NSManagedObjectContext? = nil,
												sectionNameKeyPath keyPath: String? = nil,
												cache: String? = "Root") -> Bool {
		guard self.appDBObjectModel?.entitiesByName[entityName] != nil,
			!sortDescriptors.isEmpty else {
			return false
		}
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		fetchRequest.sortDescriptors = sortDescriptors
		fetchRequest.predicate = predicate
		fetchRequest.fetchLimit = fetchLimit
		
		let contextToUse = context ?? self.appDBObjectContext
		self.appFRC = NSFetchedResultsController(fetchRequest: fetchRequest,
												 managedObjectContext: contextToUse,
												 sectionNameKeyPath: keyPath,
												 cacheName: cache)
		self.appFRC!.delegate = self
		
		return true
	}
	
	/**
	Makes the database manager's property appFRC perform a fetch, if appFRC is configured correctly.
	
	- returns: Array of fetched objects or nil, if appFRC is not configured or if the fetch failed
	*/
	public func fetchEntries() -> [NSFetchRequestResult]? {
		guard let frc = self.appFRC else {
			return nil
		}
		
		NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
		
		do {
			try frc.performFetch()
		} catch {
			devLog("Fetch failed with error: \(error)")
		}
		
		return frc.fetchedObjects
	}
	
	/**
	Deletes the passed object from the database manager's managed object context as well as from an application's persistent store.
	
	- parameters:
		- object: The object to delete
	*/
	public func deleteObject(_ object: NSManagedObject) {
		self.appDBObjectContext.delete(object)
		self.storeChangesWithErrorLogging()
	}
	
	/**
	Deletes the passed objects from the database manager's main managed object context as well as from an application's persistent store.
	
	Stores changes after each batch, printing debug logs in case of an error.
	
	- parameters:
		- objects: The objects to delete
		- batchSize: Amount of deleted objects after which the database manager attempts to store changes, before deleting more object's
	*/
	public func deleteObjects(_ objects: [NSManagedObject], withBatchSize batchSize: Int = 10) {
		var deletedObjectCounter = 0
		for object in objects {
			self.appDBObjectContext.delete(object)
			
			if deletedObjectCounter % batchSize == 0 {
				self.storeChangesWithErrorLogging()
			}
			
			deletedObjectCounter += 1
		}
		
		self.storeChangesWithErrorLogging()
	}
	
	/**
	Deletes all objects for a passed entity from the database manager's managed object context as well as from an application's persistent store.
	
	- parameters:
		- name: Name of the entity that should be deleted
	*/
	public func deleteAllEntriesForEntity(withName name: String) throws {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
		fetchRequest.includesPropertyValues = false
		
		let items = try self.appDBObjectContext.fetch(fetchRequest) as! [NSManagedObject]
		
		for item in items {
			self.appDBObjectContext.delete(item)
		}
		
		try self.storeChanges()
	}
	
	/**
	Performs a batch delete of all objects for a passed entity on an application's persistent store.
	
	Discussion
	-
	As the deletion gets performed directly on the persistent store, this method has a lighter memory footprint (entities are not loaded into memory).
	Keep in mind, however, that the managed object context is unaware of these performed changes, i.e. validation rules may not be effective.
	
	- parameters:
		- name: Name of the entity that should be deleted
	*/
	public func batchDeleteAllEntriesForEntity(withName name: String) throws {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		try self.appDBObjectContext.execute(batchDeleteRequest)
	}
	
	/**
	Stores changes made on the database manager's main managed object context to an application's persistent store, if the are any changes.
	*/
	public func storeChanges() throws {
		if self.appDBObjectContext.hasChanges {
			try self.appDBObjectContext.save()
		}
	}
	
	/**
	Stores changes made on the database manager's background managed object context to its main managed object context, if the are any changes.
	*/
	public func storeBackgroundChanges() throws {
		if self.backgroundChildContext.hasChanges {
			try self.backgroundChildContext.save()
		}
	}
	
	/**
	Stores the changes made on the database manager's managed object context to an application's persistent store, if the are any changes.
	Catches and logs all errors that might occur.
	*/
	public func storeChangesWithErrorLogging()  {
		if self.appDBObjectContext.hasChanges {
			do {
				try self.storeChanges()
			}
			catch let error as NSError {
				logErrors(containedIn: error, message: "Storing changes failed with error(s):")
				devLog("Error debug description: \(error.debugDescription)")
			}
		}
	}
}

// MARK: -
// MARK: Fetched results controller delegate conformance
extension TRIKDatabaseManager: NSFetchedResultsControllerDelegate {
}
