//
//  UIView+ViewHierarchy.swift
//  TiemzyaRiOSKit
//
//  Created by Manuel Zhou on 12.07.20.
//  Copyright © 2020 tiemzyar.
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

// MARK: -
// MARK: View Hierarchy
public extension UIView {
	// MARK: Nested types


	// MARK: Type properties


	// MARK: Type methods


	// MARK: -
	// MARK: Instance properties


	// MARK: -
	// MARK: Instance methods
	/**
	Finds the view's controller, if available, using the view's responder hierarchy.
	
	- returns: The view's view controller or nil
	*/
	func findViewController() -> UIViewController? {
		if let nextResponder = self.next as? UIViewController {
			return nextResponder
		} else if let nextResponder = self.next as? UIView {
			return nextResponder.findViewController()
		} else {
			return nil
		}
	}
	
	/**
	Recursively searches through the view's subview hierarchy to find all subviews of type `type`.
	
	- parameters:
		- type: Type of subviews to find
	
	- returns: Array of found subviews
	*/
	func getSubviewsRecursive<T : UIView>(ofType type: T.Type) -> [T] {
		var subviews = [T]()

		for subview in self.subviews {
			if let sv = subview as? T {
				subviews.append(sv)
			}
			
			subviews += subview.getSubviewsRecursive(ofType: type)
		}

		return subviews
	}
}
