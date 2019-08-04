//
//  TRIKUIDevice+Type.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 11.10.18.
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

/**
Extension of UIDevice for determining the type of the device an application is running on.

Metadata
-
Author: tiemzyar

Revision history:
- Created extension
*/
public extension UIDevice {
	/**
	Subject to a device's logical screen resolution determines on which of the following device types an application is running:
	- iPhone 5.8"
	- iPhone 5.5"
	- iPhone 4.7"
	- iPhone 4.0"
	- iPad Pro 12.9"
	- iPad Pro 10.5"
	- iPad 7.9" or 9.7" ('iPad Retina')
	*/
	func deviceType() -> String {
		var deviceType = TRIKConstant.DeviceType.unknown
		
		let idiom = self.userInterfaceIdiom
		let screenSize = UIScreen.main.bounds.size
		let screenHeightPortrait = UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? screenSize.height : screenSize.width
//		let screenScale = UIScreen.main.scale
		
		if idiom == UIUserInterfaceIdiom.phone {
			switch screenHeightPortrait {
			case 812.0:
				deviceType = TRIKConstant.DeviceType.iPhone_5_8
			case 736.0:
				deviceType = TRIKConstant.DeviceType.iPhone_5_5
			case 667.0:
				deviceType = TRIKConstant.DeviceType.iPhone_4_7
			case 568.0:
				deviceType = TRIKConstant.DeviceType.iPhone_4_0
/* Support for 3.5" devices dropped for iOS 10
			case 480.0:
				deviceType = TRIKConstant.DeviceType.iPhone_3_5*/
			default:
				break
			}
		}
		else if idiom == UIUserInterfaceIdiom.pad {
			switch screenHeightPortrait {
			case 1366.0:
				deviceType = TRIKConstant.DeviceType.iPadPro_12_9
			case 1112.0:
				deviceType = TRIKConstant.DeviceType.iPadPro_10_5
			case 1024.0:
				deviceType = TRIKConstant.DeviceType.iPadRetina
/* Support for non-retina iPad devices dropped for iOS 10
				if screenScale == 2.0 {
					deviceType = TRIKConstant.DeviceType.iPadRetina
				}
				if screenScale == 1.0 {
					deviceType = TRIKConstant.DeviceType.iPadNonRetina
				}*/
			default:
				break
			}
		}
		
		return deviceType
	}
}
