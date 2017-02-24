//
//  ViewController.swift
//  2 Project
//
//  Created by mac on 4/26/16.
//  Copyright © 2016 Alder. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //MARK: - Outlets
    @IBOutlet weak var topTextFieldConstrain: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var viewForMeme: UIView!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ] as [String : Any]
    func setupTextField(_ textField: UITextField, defaultText: String) {
        
        textField.delegate = self
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        setupTextField(topTextField, defaultText: "TOP")
        setupTextField(bottomTextField, defaultText: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    func imagePicker(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        self.present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func pickButton(_ sender: AnyObject) {
        // Show Image Picker View Controller after pressing the button
        imagePicker(.photoLibrary)
    }
    @IBAction func cameraButton(_ sender: AnyObject) {
        // Show Camera View Controller
        imagePicker(.camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        
    }
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolBar.isHidden = true
        navigationBar.isHidden = true
        // Render view to an image
        let widthOfImage:CGFloat!
        let heightOfImage:CGFloat!
        let frameForDrawing:CGRect!
        let sizeForContext:CGSize!
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            heightOfImage = imageView.frame.size.height
            widthOfImage = heightOfImage*(imageView.image!.size.width/imageView.image!.size.height)
            let x = -((imageView.frame.size.width - widthOfImage)/2)
            let y =  imageView.frame.minY
            frameForDrawing = CGRect(x: x, y: y, width: imageView.frame.size.width, height: heightOfImage)
            sizeForContext = CGSize(width: widthOfImage, height: heightOfImage)
            
            
        } else {
            widthOfImage = imageView.frame.size.width
            heightOfImage = widthOfImage*(imageView.image!.size.height/imageView.image!.size.width)
            let x = imageView.frame.minX
            let y = -((imageView.frame.size.height - heightOfImage)/2)
            frameForDrawing = CGRect(x: x, y: y, width: widthOfImage, height: imageView.frame.size.height)
            sizeForContext = CGSize(width: widthOfImage, height: heightOfImage)
            
        }
        //frameForDrawing = CGRect(x: imageView.frame.minX, y: y, width: widthOfImage, height: imageView.frame.size.height)
        print(sizeForContext)
        print(frameForDrawing)
        print(imageView.frame)
        UIGraphicsBeginImageContext(sizeForContext)
        viewForMeme.drawHierarchy(in: frameForDrawing,afterScreenUpdates: true)

        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolBar.isHidden = false
        navigationBar.isHidden = false
        return memedImage
    }
    func save() {
        //Create the meme
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, pickerViewImage: imageView.image!, memedImage: generateMemedImage())
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)

    }
    
    @IBAction func shareButtonAction(_ sender: AnyObject) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil )
        controller.completionWithItemsHandler = { (activity, success, items, error) -> Void in
            if success {
                self.save()
                self.dismiss(animated: true, completion:nil)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        dismiss(animated: true, completion:nil)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        textField.becomeFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        print("key\(keyboardSize) and \(keyboardSize.cgRectValue.height)")
        return keyboardSize.cgRectValue.height
    }
    
    
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

