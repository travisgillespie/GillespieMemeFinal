//
//  ViewController.swift
//  GillespieMemeFinal
//
//  Created by Travis Gillespie on 8/11/15.
//  Copyright (c) 2015 Travis Gillespie. All rights reserved.
//

import Foundation
import UIKit

//flow layout delegate... UICollectionViewFlowLayoutDelegate
//http://www.techotopia.com/index.php/A_Swift_iOS_8_Storyboard-based_Collection_View_Tutorial


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var selectedMeme: MemeObject!
    let textFieldTopDelegate = TextFieldTop()
    let textFieldBottomDelegate = TextFieldBottom()
    var activeTextField = UITextField()
    
    var greenColor = UIColor.greenColor()
    let appBlackColor = UIColor.blackColor()
    let appWhietColor = UIColor.whiteColor()
    let appRedColor = UIColor(red: 200.0/255.0, green: 16.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    let appSilverColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    let appWhiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    let appNavyColor = UIColor(red: 19.0/255.0, green: 41.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    
    let TextAttributes = [

        NSStrokeWidthAttributeName : -3.0,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 24)!

    ]
    
    func textFieldLayouts(name : UITextField!, position : String, color : UIColor){
        name.text = position
        name.defaultTextAttributes = TextAttributes
        name.textAlignment = NSTextAlignment.Center
        name.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var alignText = NSTextAlignment.Center
        self.textFieldTop.delegate = textFieldTopDelegate
        self.textFieldBottom.delegate = textFieldBottomDelegate
        
        textFieldLayouts(textFieldTop, position:"TOP", color: greenColor)
        textFieldLayouts(textFieldBottom, position:"BOTTOM", color: appRedColor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        

        if selectedMeme != nil {
            self.textFieldTop.text = self.selectedMeme.topText
            self.textFieldBottom.text = self.selectedMeme.bottomText
            self.pickerImageView.image = self.selectedMeme.image
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.cameraCaptureMode = .Photo
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[
            UIImagePickerControllerOriginalImage
            ] as? UIImage{
                pickerImageView.contentMode = UIViewContentMode.ScaleAspectFill
                pickerImageView.image = pickedImage
            }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var keyboardHeight = getKeyboardHeight(notification)
        if textFieldBottom.isFirstResponder() {
        if keyboardHeight > 0 {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= keyboardHeight
        } else {
            self.view.frame.origin.y -= keyboardHeight
        }
     }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    
    @IBAction func shareMemeActivityButton(sender: UIBarButtonItem) {
        let generatedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (
            type: String!,
            completion: Bool,
            items: [AnyObject]!,
            err: NSError!) in
            
            if completion {
                if self.pickerImageView.image != nil {
                    var newMeme = MemeObject (
                        topText: self.textFieldTop.text!,
                        bottomText: self.textFieldBottom.text!,
                        image : self.pickerImageView.image!,
                        memedImage : generatedImage
                    )
                    newMeme.save()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Choose A Photo", message: "don't forget the picture", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func textFieldTop(sender: UITextField) {

    }
    
    @IBAction func textFieldBottom(sender: UITextField) {

    }
    
}