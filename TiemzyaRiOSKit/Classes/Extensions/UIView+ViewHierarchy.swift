//
//  UIView+ViewHierarchy.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 12.07.20.
//  Copyright © 2020-2021 tiemzyar.
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
/*
Extension of UIView with functionality related to the view hierarchy of a view.
*/
public extension UIView {
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
		}
		
		return nil
	}
	
	/**
	Searches through the view's direct subviews to find all subviews of a given type.
	
	If `recursive` is true, this method will perform its search recursively through the view's entire subview hierarchy.
	
	- parameters:
		- type: Type of subviews to find
		- recursive: Flag about whether to search in entire subview hierarchy
	
	- returns: Array of found subviews
	*/
	func getSubviews<T : UIView>(ofType type: T.Type, recursive: Bool = false) -> [T] {
		var subviews = [T]()

		for subview in self.subviews {
			if let sv = subview as? T {
				subviews.append(sv)
			}
			
			if recursive {
				subviews += subview.getSubviews(ofType: type, recursive: true)
			}
		}

		return subviews
	}
	
	/**
	Searches through the view's superview hierarchy to find superviews of a given type.
	
	- parameters:
		- type: Type of superview to find
	
	- returns: Array of found superviews
	*/
	func getSuperviews<T : UIView>(ofType type: T.Type) -> [T] {
		var superviews = [T]()
		
		var currentView: UIView? = self
		repeat {
			if let sv = currentView?.superview as? T {
				superviews.append(sv)
			}
			
			currentView = currentView?.superview
		} while currentView != nil
		
		return superviews
	}
}
