//
//  Constants.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 25.09.18.
//  Copyright © 2018-2020 tiemzyar.
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

//==============================================================================
// MARK: -
// MARK: TRIK Constants
//==============================================================================
/**
Defines global constants used within the TRIK framework.

Metadata:
-
Author: tiemzyar

Revision history:
- Created struct
*/
public struct TRIKConstant {
	
	//==============================================================================
	// MARK: -
	// MARK: Alpha Values
	//==============================================================================
	/**
	A collection of alpha values.
	*/
	public struct AlphaValue {
		/// Alpha value of 0 %
		public static let a000: CGFloat = 0.00
		
		/// Alpha value of 10 %
		public static let a010: CGFloat = 0.10
		
		/// Alpha value of 20 %
		public static let a020: CGFloat = 0.20
		
		/// Alpha value of 25 %
		public static let a025: CGFloat = 0.25
		
		/// Alpha value of 30 %
		public static let a030: CGFloat = 0.30
		
		/// Alpha value of 40 %
		public static let a040: CGFloat = 0.40
		
		/// Alpha value of 50 %
		public static let a050: CGFloat = 0.50
		
		/// Alpha value of 60 %
		public static let a060: CGFloat = 0.60
		
		/// Alpha value of 70 %
		public static let a070: CGFloat = 0.70
		
		/// Alpha value of 75 %
		public static let a075: CGFloat = 0.75
		
		/// Alpha value of 80 %
		public static let a080: CGFloat = 0.80
		
		/// Alpha value of 90 %
		public static let a090: CGFloat = 0.90
		
		/// Alpha value of 100 %
		public static let a100: CGFloat = 1.00
		
		
		/// Alpha value of 0 %
		public static let none = a000
		
		/// Alpha value of 25 %
		public static let quarterOne = a025
		
		/// Alpha value of 50 %
		public static let half = a050
		
		/// Alpha value of 75 %
		public static let quarterThree = a075
		
		/// Alpha value of 100 %
		public static let full = a100
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Animation Times
	//==============================================================================
	/**
	A collection of standard animation times.
	*/
	public struct AnimationTime {
		/// No animation time
		public static let none = 0.00
		
		/// Short animation time
		public static let short = 0.25
		
		/// Medium animation time
		public static let medium = 0.5
		
		/// Long animation time
		public static let long = 0.75
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Colors
	//==============================================================================
	/**
	A collection of standard colors.
	*/
	public struct Color {
		
		//==============================================================================
		// MARK: -
		// MARK: Color Groups
		//==============================================================================
		/**
		A collection of blue colors.
		*/
		public struct Blue {
			/// Light blue color (#00b2e2)
			public static var light: UIColor {
				return UIColor(red: 0/255.0, green: 178/255.0, blue: 226/255.0, alpha: 1.0)
			}
			
			/// Medium blue color (#2266aa)
			public static var medium: UIColor {
				return UIColor(red: 34/255.0, green: 102/255.0, blue: 170/255.0, alpha: 1.0)
			}
			
			/// Special blue color (#154c81)
			public static var tiemzyar: UIColor {
				return UIColor(red: 21/255.0, green: 76/255.0, blue: 129/255.0, alpha: 1.0)
			}
		}
		
		/**
		A collection of green colors.
		*/
		public struct Green {
			/// Special green color (#08705f)
			public static var tiemzyar: UIColor {
				return UIColor(red: 8/255.0, green: 112/255.0, blue: 95/255.0, alpha: 1.0)
			}
		}
		
		/**
		A collection of grey colors.
		*/
		public struct Grey {
			/// Dark grey color
			public static var dark: UIColor {
				return UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1.0)
			}
			
			/// Light grey color
			public static var light: UIColor {
				return UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1.0)
			}
			
			/// Medium grey color
			public static var medium: UIColor {
				return UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
			}
		}
		
		//==============================================================================
		// MARK: -
		// MARK: Simple colors
		//==============================================================================
		/// Black color
		public static var black: UIColor {
			return .black
		}
		
		/// Clear color
		public static var clear: UIColor {
			return .clear
		}
		
		/// Red color
		public static var red: UIColor {
			return .red
		}
		
		/// White color
		public static var white: UIColor {
			return .white
		}
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Conversion
	//==============================================================================
	/**
	A collection of Byte conversion factors.
	*/
	public struct Conversion {
		/// Conversion factor byte -> KiloByte
		public static let byteKiloByte = 1024.0
		
		/// Conversion factor byte -> MegaByte
		public static let byteMegaByte = byteKiloByte * byteKiloByte
		
		/// Conversion factor byte -> GigaByte
		public static let byteGigaByte = byteMegaByte * byteKiloByte
		
		/// Conversion factor byte -> TeraByte
		public static let byteTeraByte = byteGigaByte * byteKiloByte
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Device Types
	//==============================================================================
	/**
	A collection of constants related to iOS device types.
	*/
	public struct DeviceType {
		/// 5.8" iPhone and iPod devices
		public static let iPhone_5_8 = "iPhone 5.8"
		
		/// 5.5" iPhone and iPod devices
		public static let iPhone_5_5 = "iPhone 5.5"
		
		/// 4.7" iPhone and iPod devices
		public static let iPhone_4_7 = "iPhone 4.7"
		
		/// 4.0" iPhone and iPod devices
		 public static let iPhone_4_0 = "iPhone 4.0"
		
		/// 3.5" iPhone and iPod devices
		public static let iPhone_3_5 = "iPhone 3.5"
		
		/// 12.9" iPad Pro
		public static let iPadPro_12_9 = "iPad Pro 12.9"
		
		/// 10.5" iPad Pro
		public static let iPadPro_10_5 = "iPad Pro 10.5"
		
		/// 7.9" and 9.7" iPad devices with retina display
		public static let iPadRetina = "iPad Retina"
		
		/// 7.9" and 9.7" iPad devices without retina display
		public static let iPadNonRetina = "iPad Non-Retina"
		
		/// Unknown device type
		public static let unknown = "Unknown Device Type"
	}
	
	//==============================================================================
	// MARK: -
	// MARK: File Management
	//==============================================================================
	/**
	A collection of constants related to file management.
	*/
	public struct FileManagement {
		/**
		A collection of directory names.
		*/
		public struct DirectoryName {
			/// Directory name of an application's localized content for the base localization
			public static let baseLocale = "Base"
			
			/// Core data directory name
			public static let coreData = "CoreData"
		}
		
		/**
		A collection of file names.
		*/
		public struct FileName {
			/**
			A collection of file names for .plist files containing available application languages.
			*/
			public struct ApplicationLanguages {
				/// File name for an TRIK external .plist file containing available application languages
				public static let external = "AppLanguages"
				
				/// File name for the TRIK internal .plist file containing available application languages
				public static let trik = "TRIKLanguages"
			}
			
			/**
			A collection of file names for .plist files containing a list of countries.
			*/
			public struct Countries {
				/// File name for an TRIK external .plist file containing a list of countries
				public static let external = "AppCountries"
				
				/// File name for the TRIK internal .plist file containing a list of countries
				public static let trik = "TRIKCountries"
			}
			
			/**
			A collection of CoreData related file names.
			*/
			public struct CoreData {
				/// Default file name for the CoreData database created through the TRIK framework
				public static let databaseDefault = "AppDB"
				
				/// Default file name for the CoreData model created through the TRIK framework
				public static let modelDefault = databaseDefault + "Model"
			}
			
			/// File name of the .strings file containing all localized strings used within the TRIK framework
			public static let localizedStrings = "TRIKLocalizable"
			
			/// Name of the TRIK framework bundle
			public static let trikBundle = "TiemzyaRiOSKit"
			
		}
		
		/**
		A collection of file extensions.
		*/
		public struct FileExtension {
			/// File extension .bundle
			public static let bundle = "bundle"
			
			/// File extension .framework
			public static let framework = "framework"
			
			/// File extension .heif
			public static let heif = "heif"
			
			/// File extension .html
			public static let html = "html"
			
			/// File extension .jpg
			public static let jpg = "jpg"
			
			/// File extension .json
			public static let json = "json"
			
			/// File extension .lproj
			public static let lproj = "lproj"
			
			/// File extension .momd
			public static let momd = "momd"
			
			/// File extension .pdf
			public static let pdf = "pdf"
			
			/// File extension .plist
			public static let plist = "plist"
			
			/// File extension .png
			public static let png = "png"
			
			/// File extension .sqlite
			public static let sqlite = "sqlite"
			
			/// File extension .xcdatamodel
			public static let xcDataModel = "xcdatamodel"
			
			/// File extension .xcdatamodeld
			public static let xcDataModelD = "xcdatamodeld"
			
			/// File extension .xml
			public static let xml = "xml"
			
			/// File extension .zip
			public static let zip = "zip"
		}
		
		/**
		A collection of file attributes.
		*/
		public struct FileAttribute {
			/// Attribute for the size of a file
			public static let fileSize = "NSFileSize"
		}
	}

	//==============================================================================
	// MARK: -
	// MARK: Keychain
	//==============================================================================
	/**
	A collection of constants related to Keychain management.
	*/
	public struct Keychain {
		/**
		A collection of Keychain services.
		*/
		public struct Service {
			/// Keychain service for user authentication
			public static let authentication = "UserAuthentication"
		}
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Languages
	//==============================================================================
	/**
	A collection of constants related to languages.
	*/
	public struct Language {
		/**
		A collection of language names.
		*/
		public struct Name {
			/// Language name for Arabic
			public static let arabic = "العَرَبِيَّة"
			
			/// Language name for Bengali
			public static let bengali = "বাংলা"
			
			/// Language name for Chinese
			public static let chinese = "簡體中文"
			
			/// Language name for English
			public static let english = "English"
			
			/// Language name for French
			public static let french = "Français"
			
			/// Language name for German
			public static let german = "Deutsch"
			
			/// Language name for Hindi
			public static let hindi = "हिन्दी"
			
			/// Language name for Italian
			public static let italian = "Italiano"
			
			/// Language name for Japanese
			public static let japanese = "日本語"
			
			/// Language name for Portoguese
			public static let portuguese = "Português"
			
			/// Language name for Punjabi
			public static let punjabi = "ਪੰਜਾਬੀ"
			
			/// Language name for Russian
			public static let russian = "ру́сский язы́к"
			
			/// Language name for Spanish
			public static let spanish = "Español"
		}
		
		/**
		A collection of ISO 639-1 language codes.
		*/
		public struct Code {
			/// ISO 639-1 language code for Arabic
			public static let arabic = "ar"
			
			/// ISO 639-1 language code for Bengali
			public static let bengali = "bn"
			
			/// ISO 639-1 language code for Chinese
			public static let chinese = "zh"
			
			/// ISO 639-1 language code for English
			public static let english = "en"
			
			/// ISO 639-1 language code for French
			public static let french = "fr"
			
			/// ISO 639-1 language code for German
			public static let german = "de"
			
			/// ISO 639-1 language code for Hindi
			public static let hindi = "hi"
			
			/// ISO 639-1 language code for Italian
			public static let italian = "it"
			
			/// ISO 639-1 language code for Japanese
			public static let japanese = "ja"
			
			/// ISO 639-1 language code for Portuguese
			public static let portuguese = "pt"
			
			/// ISO 639-1 language code for Punjabi
			public static let punjabi = "pa"
			
			/// ISO 639-1 language code for Russian
			public static let russian = "ru"
			
			/// ISO 639-1 language code for Spanish
			public static let spanish = "es"
		}
		
		/**
		Converts a given language code to its corresponding language name.
		
		- Parameters:
			- code: The code to convert
		
		- Returns: The language name for code
		*/
		public static func name(forCode code: String) -> String {
			let name: String
			switch code {
			case Language.Code.arabic:
				name = Language.Name.arabic
			case Language.Code.bengali:
				name = Language.Name.bengali
			case Language.Code.chinese:
				name = Language.Name.chinese
			case Language.Code.french:
				name = Language.Name.french
			case Language.Code.german:
				name = Language.Name.german
			case Language.Code.hindi:
				name = Language.Name.hindi
			case Language.Code.italian:
				name = Language.Name.italian
			case Language.Code.japanese:
				name = Language.Name.japanese
			case Language.Code.portuguese:
				name = Language.Name.portuguese
			case Language.Code.punjabi:
				name = Language.Name.punjabi
			case Language.Code.russian:
				name = Language.Name.russian
			case Language.Code.spanish:
				name = Language.Name.spanish
			default:
				name = Language.Name.english
			}
			
			return name
		}
		
		/**
		Converts a given language name to its corresponding language code.
		
		- Parameters:
			- name: The name to convert
		
		- Returns: The language code for name
		*/
		public static func code(forName name: String) -> String {
			let code: String
			switch name {
			case Language.Name.arabic:
				code = Language.Code.arabic
			case Language.Name.bengali:
				code = Language.Code.bengali
			case Language.Name.chinese:
				code = Language.Code.chinese
			case Language.Name.french:
				code = Language.Code.french
			case Language.Name.german:
				code = Language.Code.german
			case Language.Name.hindi:
				code = Language.Code.hindi
			case Language.Name.italian:
				code = Language.Code.italian
			case Language.Name.japanese:
				code = Language.Code.japanese
			case Language.Name.portuguese:
				code = Language.Code.portuguese
			case Language.Name.punjabi:
				code = Language.Code.punjabi
			case Language.Name.russian:
				code = Language.Code.russian
			case Language.Name.spanish:
				code = Language.Code.spanish
			default:
				code = Language.Code.english
			}
			
			return code
		}
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Notifications
	//==============================================================================
	/**
	A collection of constants related to Notifications.
	*/
	public struct Notification {
		/**
		A collection of notification names.
		*/
		public struct Name {
			/// Name of the notification posted in TRIKAlertVC on completion of size transitions
			public static let alertVCSizeTransitionCompleted: NSNotification.Name = NSNotification.Name("TRIK Alert VC Size Transition Completed")
			
			/// Name of the notification posted in ??? when a document preview started
			public static let docPreviewStarted: NSNotification.Name = NSNotification.Name(rawValue: "TRIK Document Preview Started")
			
			/// Name of the notification posted in ??? when a document preview ended
			public static let docPreviewEnded: NSNotification.Name = NSNotification.Name(rawValue: "TRIK Document Preview Ended")
			
			/// Name of the notification posted in TRIKLanguageOverlay when a new language has been selected
			public static let languageOverlayDidSelectLanguage: NSNotification.Name = NSNotification.Name(rawValue: "TRIK Language Overlay Did Select Language")
			
			/// Name of the notification posted in TRIKUtil's reachabilityCheck method when a No-wifi-warning-alert has been cancelled
			public static let noWifiWarningCancel: NSNotification.Name = NSNotification.Name(rawValue: "TRIK No Wifi Warning Cancel")
			
			/// Name of the notification posted in TRIKUtil's reachabilityCheck method when a No-wifi-warning-alert has been confirmed
			public static let noWifiWarningContinue: NSNotification.Name = NSNotification.Name(rawValue: "TRIK No Wifi Warning Continue")
		}
		
		/**
		A collection of notification user info dictionary keys.
		*/
		public struct Key {
			/// Key for the path of the previewed document in the user info dictionary of docPreviewStarted and docPreviewEnded notifications
			public static let docPath = "TRIK Key Document Path"
			
			/// Key for the selected language in the user info dictionary of languageOverlayDidSelectLanguage notification
			public static let selectedLanguage = "TRIK Key Selected Language"
		}
	}
	
	//==============================================================================
	// MARK: -
	// MARK: PLIST Keys
	//==============================================================================
	/**
	A collection of constants related to dictionary keys in .plist files.
	*/
	public struct PLISTKey {
		/**
		A collection of dictionary keys in a .plist file containing available application languages.
		*/
		public struct Language {
			/// Key for language availability
			public static let available = "available"
			
			/// Key for language code
			public static let code = "code"
			
			/// Key for language name
			public static let name = "name"
		}
		
		/**
		A collection of dictionary keys in a .plist file containing a list of countries.
		*/
		public struct Country {
			/// Key for country availability
			public static let available = "available"
			
			/// Key for ISO 3166 alpha-2 country code
			public static let codeA2 = "code_a2"
			
			/// Key for ISO 3166 alpha-3 country code
			public static let codeA3 = "code_a3"
			
			/// Key for ISO 3166 numeric country code
			public static let codeNum = "code_num"
			
			/// Key for local country name
			public static let local = "local"
			
			/// Key for dictionary of country names
			public static let names = "names"
		}
	}
	
	//==============================================================================
	// MARK: -
	// MARK: Special Strings
	//==============================================================================
	/**
	A collection of special string constants.
	*/
	public struct SpecialString {
		/// Empty string
		public static let empty = ""
		
		/// Meaning of Life the Universe and Everything
		public static let moltuae = "MoLtUaE"
		
		/// New line
		public static let newLine = "\n"
		
		/// Space
		public static let space = " "
	}
	
	//==============================================================================
	// MARK: -
	// MARK: User Defaults
	//==============================================================================
	/**
	A collection of user default keys.
	*/
	public struct UserDefaults {
		/// User default key apple languages
		public static let appleLanguages = "AppleLanguages"
		/// User default key available languages
		public static let availableLanguages = "TRIK Available Languages"
		/// User default key selected language
		public static let selectedLanguage = "TRIK Selected Language"
		
		/**
		TRIK framework pdf reader specific user default keys.
		*/
		public struct TRIKReader {
			/// User default key flatten UI
			public static let flattenUI = "TRIK Flatten UI"
		}
	}
	
	//==============================================================================
	// MARK: -
	// MARK: View Shadow
	//==============================================================================
	/**
	A collection of constants related to view shadows.
	*/
	public struct ViewShadow {
		/**
		A collection of view shadow opacity levels.
		*/
		public struct Opacity {
			/// View shadow opacity of 35 %
			public static let heavy = 0.35
			
			/// View shadow opacity of 0 %
			public static let highlighted = 0.0
			
			/// View shadow opacity of 15 %
			public static let light = 0.15
			
			/// View shadow opacity of 25 %
			public static let medium = 0.25
		}
		
		/// View shadow offset on x- and y-axis
		public static let offsetXY = 5.0
		
		/// View shadow radius
		public static let radius = 7.0
	}
}




