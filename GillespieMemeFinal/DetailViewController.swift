//
//  DetailViewController.swift
//  GillespieMemeFinal
//
//  Created by Travis Gillespie on 8/12/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var memedImageView: UIImageView!
    var selectedMeme: MemeObject!
    var selectedMemeArrayIndex: Int!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memedImageView.image = selectedMeme.memedImage
    }
    
    @IBAction func trashButton(sender: AnyObject) {
        memedImageView.removeFromSuperview()
        memedImageView = nil
        trashButton.hidden = true
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(selectedMemeArrayIndex)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination: ViewController = segue.destinationViewController as! ViewController
        destination.selectedMeme = selectedMeme
    }
}