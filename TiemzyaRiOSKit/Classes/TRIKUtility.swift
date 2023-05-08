//
//  TRIKUtil.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 25.09.18.
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

import Foundation
import CoreData
import AVFoundation
import Alamofire

// MARK: -
// MARK: Global methods

// MARK: Localization
/**
Retrieves a localized string for a given key from a given bundle and table.

Discussion
-
The optional fallback language will be used, if there is no string associated with the given key for the current application language.

- parameters:
	- key: The key for the localized string
	- bundle: The bundle containing the file with localized strings
				(default: `Bundle.main`)
	- table: The name of the .strings file containing the localized string
				(default: nil, i.e. Localizable.strings)
	- code: Code for the fallback language to use
				(default: `TRIKConstant.Language.Code.english`)

- returns: The localized string or ``TRIKConstant.SpecialString.moltuae``, if there is no string associated with the given key
*/
public func localizedString(forKey key: String,
							bundle: Bundle = Bundle.main,
							table: String? = nil,
							fallback code: String? = TRIKConstant.Language.Code.english) -> String {
	
	// Try using directory of locale for current language
	var path = bundle.path(forResource: TRIKUtil.Language.currentLanguage().languageCode,
						   ofType: TRIKConstant.FileManagement.FileExtension.lproj)
	
	// Try using directory of fallback locale
	if path == nil && code != nil {
		path = bundle.path(forResource: code,
						   ofType: TRIKConstant.FileManagement.FileExtension.lproj)
	}
	
	// Try using directory of base locale as last resort
	if path == nil && code != TRIKConstant.FileManagement.DirectoryName.baseLocale {
		path = bundle.path(forResource: TRIKConstant.FileManagement.DirectoryName.baseLocale,
						   ofType: TRIKConstant.FileManagement.FileExtension.lproj)
	}
	
	// Guard that one of above directories exists
	guard let langBundlePath = path else {
		return TRIKConstant.SpecialString.moltuae
	}
	
	guard let langBundle = Bundle(path: langBundlePath) else {
		return TRIKConstant.SpecialString.moltuae
	}
	
	return langBundle.localizedString(forKey: key, value: TRIKConstant.SpecialString.moltuae, table: table)
}

// MARK: Logging
/**
Logs a string (or the string-reflection of an object) to the console.

The logging-functionality is only active, when a project is run in debug-mode. When run in release-mode, the functionality is deactivated.

- parameters:
	- object: Object to log
	- file: File the log statement appears in
	- function: Function the log statement appears in
	- line: Line of code of the respective file the log statement appears in
*/
public func devLog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
	#if DEBUGLOGS
		var log: String
		if let objString = object() as? String {
			log = objString
		}
		else {
			log = String(reflecting: object())
		}
		let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
		let queue = Thread.isMainThread ? "UI" : "BG"
		
		print("[\(fileURL), line \(line) > \(function), \(queue)] Dev: " + log)
	#endif
}

#if NOLOGS
	/**
	Deactivates the system function `print(...)`, if NOLOGS is defined in the 'Active Compilation Conditions' section of this framework's build settings.
	*/
	public func print(_ items: Any...) {}
#endif

/**
After an initial message, logs all detailed errors contained within an NSError instance. If there are no detailed errors, only the error itself will be logged.

- parameters:
	- error: The error(s) to log
	- message: Message to display before the actual error log
*/
public func logErrors(containedIn error: NSError, message: String) {
	// Create error log
	var logComposition = """
		\(message)
		"""
	
	// Append error information
	logComposition += """
		\nError:
			- Description: \(error.localizedDescription)
			- Failure reason: \(error.localizedFailureReason ?? "nil")
			- Help anchor: \(error.helpAnchor ?? "nil")
			- Recovery suggestion: \(error.localizedRecoverySuggestion ?? "nil")
		"""
	
	// Append detailed errors, if available
	if let errors = error.userInfo[NSDetailedErrorsKey] as? [Error] {
		for error in errors {
			if let localizedError = error as? LocalizedError {
				logComposition += """
						\nDetailed error:
							- Description: \(localizedError.errorDescription ?? localizedError.localizedDescription)
							- Failure reason: \(localizedError.failureReason ?? "nil")
							- Help anchor: \(localizedError.helpAnchor ?? "nil")
							- Recovery suggestion: \(localizedError.recoverySuggestion ?? "nil")
					"""
			}
			else {
				logComposition += """
						\nDetailed error:
							- Description: \(error.localizedDescription)
					"""
			}
		}
	}
	
	devLog(logComposition)
}

// MARK: -
// MARK: Utility
/**
Class containing utility methods for retrieving the TRIK framework's bundle and resource boundle.
*/
public final class TRIKUtil {
	/**
	Retrieves the TRIK framework's bundle.
	
	- returns: The TRIK framework's bundle
	*/
	public static func trikBundle() -> Bundle {
		return Bundle(for: self)
	}
	
	/**
	Retrieves the TRIK framework's resource bundle.
	
	Discussion
	-
	A framework's resource bundle is nested inside the framework bundle.
	See: https://stackoverflow.com/a/35903720
	
	- returns: The TRIK framework's resource bundle
	*/
	public static func trikResourceBundle() -> Bundle? {
		let fileName = TRIKConstant.FileManagement.FileName.trikBundle
		let fileExt = TRIKConstant.FileManagement.FileExtension.bundle
		
		guard let bundleURL = self.trikBundle().resourceURL?.appendingPathComponent(fileName).appendingPathExtension(fileExt) else {
			return nil
		}
		
		return Bundle(url: bundleURL)
	}
}

// MARK: -
// MARK: File Management
extension TRIKUtil {
	/**
	A collection of file management related utility methods.
	*/
	public struct FileManagement {
		/**
		Utility function for checking device support for specific file types.
		
		- parameters:
			- type: File type whose support on the current device should be checked
		*/
		public static func deviceSupportsFileFormat(type: AVFileType) -> Bool {
			let supportedTypes = CGImageDestinationCopyTypeIdentifiers() as NSArray
			
			return supportedTypes.contains(type.rawValue)
		}
		
		/**
		Utility function for getting the url of the application caches directory.
		
		- returns: Application caches directory url
		*/
		public static func getApplicationCachesDirectoryURL() -> URL {
			return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
		}
		
		/**
		Utility function for getting the url of the application documents directory.
		
		- returns: Application documents directory url
		*/
		public static func getApplicationDocumentsDirectoryURL() -> URL {
			return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
		}
		
		/**
		Utility function for getting the url of the application library directory.
		
		- returns: Application library directory url
		*/
		public static func getApplicationLibraryDirectoryURL() -> URL {
			return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!
		}
		
		/**
		Trims the file extension from a file name.

		Discussion
		-
		If the file name does not have an extension, simply returns the passed file name.

		- parameters:
			- fileName: Name of the file whose file extension should be trimmed.

		- returns: The trimmed file name
		*/
		public static func trimFileExtension(fromFile fileName: String) -> String {
			let separator = "."
			var components = fileName.components(separatedBy: separator)
			guard components.count > 1 else {
				return fileName
			}
			components.removeLast()
			
			return components.joined(separator: separator)
		}
	}
}

// MARK: -
// MARK: Application Language & Localization
extension TRIKUtil {
	/**
	A collection of language related utility methods.
	*/
	public struct Language {
		// Used for unit testing purposes only
		internal static var languageFileTestPath: String?
		
		/**
		Subject to the parameter externalFile checks whether the TRIK framework internal languages file or an external languages file is valid.

		- parameters:
			- externalFile: Flag about whether to check the TRIK framework internal or an external languages file

		- returns: Tuple consisting of a boolean representing the validity state of the checked file and an array containing the file contents, if the file is valid
		*/
		internal static func checkLanguagesFileValidity(forExternalFile externalFile: Bool = false) -> (valid: Bool, content: [Dictionary<String, Any>]?) {
			var retValue:(Bool, [Dictionary<String, Any>]?) = (valid: false, content: nil)
			
			var path: String?
			if externalFile {
				if let tPath = TRIKUtil.Language.languageFileTestPath {
					guard FileManager.default.fileExists(atPath: tPath) else {
						return retValue
					}
					path = tPath
				}
				else {
					// Guard existence of external languages file
					guard let externalPath = Bundle.main.path(forResource: TRIKConstant.FileManagement.FileName.ApplicationLanguages.external, ofType: TRIKConstant.FileManagement.FileExtension.plist) else {
						return retValue
					}
					path = externalPath
				}
			}
			else {
				// Guard existence of TRIK framework languages file
				guard let internalPath = TRIKUtil.trikResourceBundle()?.path(forResource: TRIKConstant.FileManagement.FileName.ApplicationLanguages.trik, ofType: TRIKConstant.FileManagement.FileExtension.plist) else {
					return retValue
				}
				path = internalPath
			}
			
			// Guard creation of plist data from languages file succeeds
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
			guard let languages = plist as? [Dictionary<String, Any>] else {
				return retValue
			}
			
			// Guard plist has content
			guard !languages.isEmpty else {
				return retValue
			}
			
			// Check that all language dicts contain correct keys
			for dict in languages {
				if dict[TRIKConstant.PLISTKey.Language.name] as? String == nil ||
					dict[TRIKConstant.PLISTKey.Language.code] as? String == nil ||
					dict[TRIKConstant.PLISTKey.Language.available] as? Bool == nil {
					return retValue
				}
			}
			
			retValue = (valid: true, content: languages)
			
			return retValue
		}
		
		/**
		Retrieves the current application language as ISO 639-1 language code or a fallback code, if it was not possible to retrieve the current application language.

		- parameters:
			- fallback: An optional fallback code
						(default: TRIKConstant.Language.Code.english)

		- returns: Tuple consisting of a language code and a Bool about whether that code is a fallback
		*/
		public static func currentLanguage(withFallback fallback: String = TRIKConstant.Language.Code.english)
		-> (languageCode: String, isFallback: Bool) {
			
			let retValue = (languageCode: fallback, isFallback: true)
			let languages = UserDefaults.standard.object(forKey: TRIKConstant.UserDefaults.appleLanguages)
			
			guard let currentLanguage = (languages as? [String])?.first else {
				return retValue
			}
			
			var applicationLanguages: [Dictionary<String, Any>] = []
			
			let externalFile = self.checkLanguagesFileValidity(forExternalFile: true)
			if externalFile.valid {
				applicationLanguages = externalFile.content!
			}
			else {
				let internalFile = self.checkLanguagesFileValidity()
				if internalFile.valid {
					applicationLanguages = internalFile.content!
				}
				else {
					return retValue
				}
			}
			
			var allLanguages: [String] = []
			for dict in applicationLanguages {
				if let available = dict[TRIKConstant.PLISTKey.Language.available] as? Bool {
					if available {
						if let language = dict[TRIKConstant.PLISTKey.Language.code] as? String {
							allLanguages.append(language)
						}
					}
				}
			}
			
			for language in allLanguages {
				if currentLanguage.hasPrefix(language) {
					return (languageCode: language, isFallback: false)
				}
			}
			
			return retValue
		}
	}
}

// MARK: -
// MARK: Network
extension TRIKUtil {
	/**
	A collection of network related utility methods.
	*/
	public struct Network {
		/// Shared network reachability manager for an application
		public static let sharedReachabilityManager = Alamofire.NetworkReachabilityManager()

		/**
		Starts monitoring network reachability in an application.
		
		- parameters:
			- listener: Optional closure for listening to reachability status changes
		*/
		public static func startMonitoringReachability(listener: ((NetworkReachabilityManager.NetworkReachabilityStatus) -> ())? = nil) {
			self.sharedReachabilityManager?.startListening {status in
				guard let actualListener = listener else {
					return
				}
				
				actualListener(status)
			}
		}

		/**
		Performs a network reachability check.

		- parameters:
			- alert: Flag about whether or not to show an alert, if no network is reachable (default: `false`)
			- warning: Flag about whether or not to show a warning, if network is only reachable over cellular (default: `false`)
			- completion: Completion handler to execute after checking reachability

		- returns: Network availability status (within completion)
		*/
		public static func reachabilityCheck(withAlert alert: Bool = false,
											 cellularWarning warning: Bool = false,
											 completion: @escaping (_ availabilityStatus: (isNetworkAvailable: Bool, isCellularNetwork: Bool)) -> Void) {
			
			var networkAvailablilityStatus = (isNetworkAvailable: false, isCellularNetwork: false)
			
			var locAlertTitle: String
			var locAlertMessage: String
			var locButtonTitleDestructive: String
			var locButtonTitleCancel: String
			
			guard let reachabilityStatus = self.sharedReachabilityManager?.status else {
				return completion(networkAvailablilityStatus)
			}
			
			if reachabilityStatus == .notReachable || reachabilityStatus == .unknown {
				if alert, let bundle = TRIKUtil.trikResourceBundle() {
					locAlertTitle = localizedString(forKey: "TRIKUtil: Alert noNetwork Title",
													bundle: bundle,
													table: TRIKConstant.FileManagement.FileName.localizedStrings)
					locAlertMessage = localizedString(forKey: "TRIKUtil: Alert noNetwork Message",
													  bundle: bundle,
													  table: TRIKConstant.FileManagement.FileName.localizedStrings)
					locButtonTitleCancel = localizedString(forKey: "TRIKUtil: Alert noNetwork Button Cancel",
														   bundle: bundle,
														   table: TRIKConstant.FileManagement.FileName.localizedStrings)
					
					let noNetwork = UIAlertController(title: locAlertTitle,
													  message: locAlertMessage,
													  preferredStyle: UIAlertController.Style.alert)
					let action = UIAlertAction(title: locButtonTitleCancel,
											   style: UIAlertAction.Style.default,
											   handler: nil)
					noNetwork.addAction(action)
					
					noNetwork.show(animated: true)
				}
				
				completion(networkAvailablilityStatus)
			}
			else {
				networkAvailablilityStatus.isNetworkAvailable = true
				
				if reachabilityStatus == .reachable(.cellular) {
					networkAvailablilityStatus.isCellularNetwork = true
					
					if warning, let bundle = TRIKUtil.trikResourceBundle() {
						locAlertTitle = localizedString(forKey: "TRIKUtil: Alert noWifi Title",
														bundle: bundle,
														table: TRIKConstant.FileManagement.FileName.localizedStrings)
						locAlertMessage = localizedString(forKey: "TRIKUtil: Alert noWifi Message",
														  bundle: bundle,
														  table: TRIKConstant.FileManagement.FileName.localizedStrings)
						locButtonTitleCancel = localizedString(forKey: "TRIKUtil: Alert noWifi Button Cancel",
															   bundle: bundle,
															   table: TRIKConstant.FileManagement.FileName.localizedStrings)
						locButtonTitleDestructive = localizedString(forKey: "TRIKUtil: Alert noWifi Button Destructive",
																	bundle: bundle,
																	table: TRIKConstant.FileManagement.FileName.localizedStrings)
						
						let noWifi = UIAlertController(title: locAlertTitle,
													   message: locAlertMessage,
													   preferredStyle: UIAlertController.Style.alert)
						var action = UIAlertAction(title: locButtonTitleDestructive,
												   style: UIAlertAction.Style.destructive,
												   handler: { (destructiveAction) in
													NotificationCenter.default.post(name: TRIKConstant.Notification.Name.noWifiWarningContinue, object: nil)
						})
						noWifi.addAction(action)
						action = UIAlertAction(title: locButtonTitleCancel,
											   style: UIAlertAction.Style.cancel,
											   handler: { (cancelAction) in
												NotificationCenter.default.post(name: TRIKConstant.Notification.Name.noWifiWarningCancel, object: nil)
						})
						noWifi.addAction(action)
						
						noWifi.show(animated: true)
					}
				}
			}
			
			return completion(networkAvailablilityStatus)
		}
		
		@available(*, deprecated, message: "This method will always return false; use 'reachabilityCheck(withAlert:cellularWarning:completion:)' instead")
		public static func reachabilityCheck(withAlert alert: Bool = true, cellularWarning warning: Bool = false) -> Bool {
			return false
		}
	}
}


// MARK: -
// MARK: Legacy methods and variables

@available(*, deprecated, message: "Use 'localizedString(forKey:bundle:table:fallback:)' instead")
public func localizedString(for key: String,
							in bundle: Bundle = Bundle.main,
							and table: String? = nil,
							fallback code: String? = nil) -> String {
	
	return localizedString(forKey: key, bundle: bundle, table: table, fallback: code)
}
