//
//  TextFieldBottom.swift
//  GillespieMemeFinal
//
//  Created by Travis Gillespie on 8/11/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

class TextFieldBottom : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}