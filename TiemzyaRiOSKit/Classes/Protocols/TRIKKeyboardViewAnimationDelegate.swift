//
//  TRIKKeyboardViewAnimationDelegate.swift
//  TiemzyaRiOSKit
//
//  Created by tiemzyar on 26.09.18.
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
Protocol for delegates that should perform view animations on keyboard appearance respectively disappearance.

Discussion
-
The class TRIKTextInputVC implements that kind of view animation functionality. If you make a controller inherit from TRIKTextInputVC, you do not need to worry about the correct implementation of animation functionality yourself.

You simply have to set activeView then.

Metadata
-
Author: tiemzyar

Revision history:
- Created protocol
*/
public protocol TRIKKeyboardViewAnimationDelegate {
	/// Variable for referencing the currently active view in a controller to enable view animations
	var activeView: UIView? {get set}
}
