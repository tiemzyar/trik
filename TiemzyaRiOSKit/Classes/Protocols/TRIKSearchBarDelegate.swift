//
//  TRIKSearchBarDelegate.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 30.10.18.
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


/**
Protocol for delegates of a search bar.

Metadata
-
Author: tiemzyar

Revision history:
- Created protocol
*/
public protocol TRIKSearchBarDelegate {
	/**
	Delegate should react to the begin of a text edit in an TRIKSearchBar instance.
	
	- parameters:
		- searchBar: The TRIKSearchBar instance delegating the begin of an edit
	*/
	func searchBarTextDidBeginEditing(_ searchBar: TRIKSearchBar)
	
	/**
	Delegate should react to the end of a text edit in an TRIKSearchBar instance.
	
	- parameters:
		- searchBar: The TRIKSearchBar instance delegating the end of an edit
	*/
	func searchBarTextDidEndEditing(_ searchBar: TRIKSearchBar)
	
	/**
	Delegate should react to text changes in an TRIKSearchBar instance.
	
	- parameters:
		- searchBar: The TRIKSearchBar instance delegating its text change
	*/
	func searchBar(_ searchBar: TRIKSearchBar, textDidChange searchText: String)
	
	/**
	Delegate should react to the tap of an TRIKSearchBar instance's cancel button.
	
	- parameters:
		- searchBar: The TRIKSearchBar instance delegating the tap of its cancel button
	*/
	func searchBarCancelButtonClicked(_ searchBar: TRIKSearchBar)
	
	/**
	Delegate should react to the tap of the system keyboard's return button when an TRIKSearchBar instance is first responder.
	
	- parameters:
		- searchBar: The TRIKSearchBar instance delegating the tap of the system keyboard's return  button
	*/
	func searchBarSearchButtonClicked(_ searchBar: TRIKSearchBar)
}
