//
//  MemeEditorViewController.swift
//  MemeMe1.0
//
//  Created by Dan Henshaw on 23/5/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar! //Bottom toolbar
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbarTop: UIToolbar!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardWillShowNotifications()
        subscribeToKeyboardWillHideNotifications()
        shareButton.isEnabled = !(imagePickerView.image == nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardWillHideNotifications()
    }
    
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField(textField: textFieldTop)
        prepareTextField(textField: textFieldBottom)
    }
    
    func prepareTextField(textField: UITextField) {
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.none
        textField.backgroundColor = UIColor.clear
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        pick(sourceType: .photoLibrary)
    }

    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        pick(sourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                let _ = self.save()
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    func keyboardWillShow(_ notification: Notification) {
        if view.frame.origin.y == 0 && textFieldBottom.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(_ notification: Notification) {
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardWillShowNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHideNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        
        let meme = Meme (topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    func navbarAndToolbarHide(_ hide: Bool){
        self.navigationController?.setNavigationBarHidden(hide, animated: hide)
        toolbar.isHidden = hide
        toolbarTop.isHidden = hide
        albumButton.accessibilityElementsHidden = hide
        cameraButton.accessibilityElementsHidden = hide
        shareButton.accessibilityElementsHidden = hide
        
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navbarAndToolbarHide(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        navbarAndToolbarHide(false)
        
        return memedImage
    }
    
    @IBAction func CancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

