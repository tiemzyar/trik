//
//  TRIKLanguageTVCell.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 09.10.18.
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

/**
A custom cell for table views showing an overview of available application languages.

Metadata
-
Author: tiemzyar

Revision history:
- Created cell
*/
public class TRIKLanguageTVCell: UITableViewCell {
	// MARK: Nested types
	
	
	// MARK: Type properties

	
	// MARK: Type methods
	
	
	// MARK: -
	// MARK: Instance properties
	/// Label storing the name of a language
	@IBOutlet public weak var nameLabel: UILabel!
	
	/// Checkmark image for indicating the currently selected language
	@IBOutlet public weak var checkmark: UIImageView!
	
	/// Stores the ISO 639-1 language code of the represented language
	public var isoCode: String?
	
	// MARK: -
	// MARK: View lifecycle
	
	
	// MARK: -
	// MARK: Instance methods
    
    
}
