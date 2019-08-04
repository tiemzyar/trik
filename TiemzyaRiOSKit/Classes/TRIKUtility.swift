//
//  TRIKUtil.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 25.09.18.
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
import CoreData
import Alamofire

//==============================================================================
// MARK: -
// MARK: Logging
//==============================================================================
/**
Logs a string (or the string reflection of an object) to the console if DEBUGLOGS is defined in the 'Other Swift Flags' section of a project's build settings.

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
	Deactivates the system print function if NOLOGS is defined in the 'Other Swift Flags' section of a project's build settings.
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


//==============================================================================
// MARK: -
// MARK: File manangement
//==============================================================================
/**
Class containing utility methods for retrieving the TRIK framework's bundle and resource boundle.

Metadata:
-
Author: tiemzyar

Revision history:
- Created class
*/
public final class TRIKUtil {
	internal static var languageFileTestPath: String?
	
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

/**
Convenience method for retrieving the path to an application's documents directory.

- returns: Path to an application's documents directory
*/
public func applicationDocumentsDirectory() -> String {
	return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
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
public func trimFileExtension(fromFile fileName: String) -> String {
	let separator = "."
	var components = fileName.components(separatedBy: separator)
	guard components.count > 1 else {
		return fileName
	}
	components.removeLast()
	
	return components.joined(separator: separator)
}

//==============================================================================
// MARK: -
// MARK: Application Language & Localization
//==============================================================================
/**
Subject to the parameter externalFile checks whether the TRIK framework internal languages file or an external languages file is valid.

- parameters:
	- externalFile: Flag about whether to check the TRIK framework internal or an external languages file

- returns: Tuple consisting of a boolean representing the validity state of the checked file and an array containing the file contents, if the file is valid
*/
internal func checkLanguagesFileValidity(forExternalFile externalFile: Bool = false) -> (valid: Bool, content: [Dictionary<String, Any>]?) {
	var retValue:(Bool, [Dictionary<String, Any>]?) = (valid: false, content: nil)
	
	var path: String?
	if externalFile {
		if let tPath = TRIKUtil.languageFileTestPath {
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
public func currentLanguage(withFallback fallback: String = TRIKConstant.Language.Code.english) -> (languageCode: String, isFallback: Bool) {
	let retValue = (languageCode: fallback, isFallback: true)
	let languages = UserDefaults.standard.object(forKey: TRIKConstant.UserDefaults.appleLanguages)
	
	guard let currentLanguage = (languages as? [String])?.first else {
		return retValue
	}
	
	var applicationLanguages: [Dictionary<String, Any>] = []
	
	let externalFile = checkLanguagesFileValidity(forExternalFile: true)
	if externalFile.valid {
		applicationLanguages = externalFile.content!
	}
	else {
		let internalFile = checkLanguagesFileValidity()
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

/**
Retrieves a localized string for the passed key from a passed bundle and table.

Discussion
-
The optional fallback language will be used if for the current application language there is no string associated with key.

- parameters:
	- key: The key for the localized string
	- bundle: The bundle containing the file with localized strings
				(default: Bundle.main)
	- table: The name of the .strings file containing the localized string
				(default: nil, i.e. Localizable.strings)
	- code: Code for the fallback language to use
				(default: nil)

- returns: The localized string or TRIKConstant.SpecialString.moltuae, if there is no string associated with key
*/
public func localizedString(for key: String,
							in bundle: Bundle = Bundle.main,
							and table: String? = nil,
							fallback code: String? = nil) -> String {
	// Try using directory of locale for current language
	var path = bundle.path(forResource: currentLanguage().languageCode,
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

//==============================================================================
// MARK: -
// MARK: Network reachability
//==============================================================================

/// Shared network reachability manager for an application
public let sharedReachabilityManager = Alamofire.NetworkReachabilityManager()

/**
Starts monitoring network reachability in an application.
*/
public func startMonitoringReachability() {
	sharedReachabilityManager?.startListening()
}

/**
Performs a network reachability check.

- parameters:
	- alert: Flag about whether or not to show an alert, if no network is reachable
	- warning: Flag about whether or not to show a warning, if network is only reachable over wwan

- returns: True, if network is available, false otherwise
*/
public func reachabilityCheck(withAlert alert: Bool = true, cellularWarning warning: Bool = false) -> Bool {
	var networkAvailable = false
	
	var locAlertTitle: String
	var locAlertMessage: String
	var locButtonTitleDestructive: String
	var locButtonTitleCancel: String
	
	guard let reachabilityStatus = sharedReachabilityManager?.networkReachabilityStatus else {
		return networkAvailable
	}
	if reachabilityStatus == .notReachable || reachabilityStatus == .unknown {
		guard let bundle = TRIKUtil.trikResourceBundle() else {
			return networkAvailable
		}
		if alert {
			locAlertTitle = localizedString(for: "TRIKUtil: Alert noNetwork Title",
											in: bundle,
											and: TRIKConstant.FileManagement.FileName.localizedStrings,
											fallback: TRIKConstant.Language.Code.english)
			locAlertMessage = localizedString(for: "TRIKUtil: Alert noNetwork Message",
											  in: bundle,
											  and: TRIKConstant.FileManagement.FileName.localizedStrings,
											  fallback: TRIKConstant.Language.Code.english)
			locButtonTitleCancel = localizedString(for: "TRIKUtil: Alert noNetwork Button Cancel",
												   in: bundle,
												   and: TRIKConstant.FileManagement.FileName.localizedStrings,
												   fallback: TRIKConstant.Language.Code.english)
			
			let noNetwork = UIAlertController(title: locAlertTitle,
											  message: locAlertMessage,
											  preferredStyle: UIAlertControllerStyle.alert)
			let action = UIAlertAction(title: locButtonTitleCancel,
									   style: UIAlertActionStyle.default,
									   handler: nil)
			noNetwork.addAction(action)
			
			noNetwork.show(animated: true)
		}
	}
	else {
		networkAvailable = true
		
		if reachabilityStatus == .reachable(NetworkReachabilityManager.ConnectionType.wwan) && warning {
			guard let bundle = TRIKUtil.trikResourceBundle() else {
				return networkAvailable
			}
			
			locAlertTitle = localizedString(for: "TRIKUtil: Alert noWifi Title",
											in: bundle,
											and: TRIKConstant.FileManagement.FileName.localizedStrings,
											fallback: TRIKConstant.Language.Code.english)
			locAlertMessage = localizedString(for: "TRIKUtil: Alert noWifi Message",
											  in: bundle,
											  and: TRIKConstant.FileManagement.FileName.localizedStrings,
											  fallback: TRIKConstant.Language.Code.english)
			locButtonTitleCancel = localizedString(for: "TRIKUtil: Alert noWifi Button Cancel",
												   in: bundle,
												   and: TRIKConstant.FileManagement.FileName.localizedStrings,
												   fallback: TRIKConstant.Language.Code.english)
			locButtonTitleDestructive = localizedString(for: "TRIKUtil: Alert noWifi Button Destructive",
														in: bundle,
														and: TRIKConstant.FileManagement.FileName.localizedStrings,
														fallback: TRIKConstant.Language.Code.english)
			
			let noWifi = UIAlertController(title: locAlertTitle,
										   message: locAlertMessage,
										   preferredStyle: UIAlertControllerStyle.alert)
			var action = UIAlertAction(title: locButtonTitleDestructive,
									   style: UIAlertActionStyle.destructive,
									   handler: { (destructiveAction) in
										NotificationCenter.default.post(name: TRIKConstant.Notification.Name.noWifiWarningContinue, object: nil)
			})
			noWifi.addAction(action)
			action = UIAlertAction(title: locButtonTitleCancel,
								   style: UIAlertActionStyle.cancel,
								   handler: { (cancelAction) in
									NotificationCenter.default.post(name: TRIKConstant.Notification.Name.noWifiWarningCancel, object: nil)
			})
			noWifi.addAction(action)
			
			noWifi.show(animated: true)
		}
	}
	
	return networkAvailable
}
