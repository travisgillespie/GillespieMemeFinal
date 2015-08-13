//
//  MemeObject.swift
//  GillespieMemeFinal
//
//  Created by Travis Gillespie on 8/11/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

struct MemeObject {
    var topText : String = ""
    var bottomText : String = ""
    var image : UIImage
    var memedImage : UIImage
    
    func save() {
        var meme = MemeObject (topText: topText, bottomText: bottomText, image : image, memedImage : memedImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
}