//
//  ConmposeViewController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 5/16/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit
import OKSGutteredCodeView
import SafariServices

class ConmposeViewController: UIViewController, CodeViewDelegate, UIWebViewDelegate {

    @IBOutlet weak var composeView: OKSGutteredCodeView!
    @IBOutlet weak var previewWebView: UIWebView!
    @IBOutlet weak var previewWidth: NSLayoutConstraint!
    @IBOutlet weak var codeViewBottomOffSet: NSLayoutConstraint!
    
    var previewVisable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //composeview set up
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(askForiCloud), name: Constants.askForiCloudnotification, object: nil)
       
        
        self.composeView.setfont(UIFont(name: "Hack", size: 17.0)!)
        self.composeView.delegate = self
        
        if !DocumentManager.appHasBeenOpen() {
            self.composeView.setText(DocumentManager.defaultString())
        } else if DocumentManager.previousDocumentAvailable() {
            DocumentManager.sharedInstance.openDocumentWithName(NSUserDefaults.standardUserDefaults().stringForKey(Constants.previouslyOpenDocument)!)
        } else {
            self.composeView.setText("")
        }
        //Keyboard toolbar set up
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 70))
        
        let quoteButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "quote3x"), style: .Plain, target: self, action: #selector(addQuote))
        let linkButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Link3x"), style: .Plain, target: self, action: #selector(addLink))
        let imageButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Image3x"), style: .Plain, target: self, action: #selector(addImage))
        let codeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Code3x"), style: .Plain, target: self, action: #selector(addCodeBlock))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? 15 : 50
        toolbar.items = [flexSpace, quoteButton, fixedSpace, linkButton, fixedSpace, imageButton, fixedSpace, codeButton, flexSpace]
        
        self.composeView.addTextViewAccessoryView(toolbar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPreview(sender: AnyObject) {
        if self.previewVisable {
            self.previewVisable = false
            self.previewWidth.constant = 1
            UIView.animateWithDuration(0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.previewVisable = true
            self.previewWidth.constant = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact ? self.view.bounds.width - 1 : self.view.bounds.width / 2
            UIView.animateWithDuration(0.5, animations: { 
                self.view.layoutIfNeeded()
            })
        }
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if self.previewVisable {
            self.performSelector(#selector(rotatePreview), withObject: nil, afterDelay: 0.25)
            
        }
    }

    func rotatePreview() {
        self.previewWidth.constant = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact ? self.view.bounds.width : self.view.bounds.width / 2

    }
    
//MARK: insertion methods
    
    func addQuote() {
        self.composeView.insertTextAtCurser(">")
    }
    
    func addLink() {
        let alertView: UIAlertController = UIAlertController(title: "New Link", message: nil, preferredStyle: .Alert)
        
        alertView.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "Alt Text"
        }
        alertView.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "Link URL"
        }
        
        let altTextField = alertView.textFields![0] as UITextField
        let LinkTextField = alertView.textFields![1] as UITextField

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        let insertAction = UIAlertAction(title: "Insert", style: .Default) { (action) in
            if LinkTextField.text! != "" {
                self.composeView.insertTextAtCurser("[\(altTextField.text! != "" ? altTextField.text! : "Click here")](\(LinkTextField.text!))")
            }
        }
        alertView.addAction(cancelAction)
        alertView.addAction(insertAction)
        
        self.presentViewController(alertView, animated: true) { 
            
        }
    }
    
    func addImage() {
        let alertView: UIAlertController = UIAlertController(title: "New Image", message: nil, preferredStyle: .Alert)
        
        alertView.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "Alt Text"
        }
        alertView.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "Image URL"
        }
        
        let altTextField = alertView.textFields![0] as UITextField
        let LinkTextField = alertView.textFields![1] as UITextField
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        let insertAction = UIAlertAction(title: "Insert", style: .Default) { (action) in
            if LinkTextField.text! != "" {
                self.composeView.insertTextAtCurser("![\(altTextField.text! != "" ? altTextField.text! : "Click here")](\(LinkTextField.text!))")
            }
        }
        alertView.addAction(cancelAction)
        alertView.addAction(insertAction)
        
        self.presentViewController(alertView, animated: true) {
            
        }
    }
    
    func addCodeBlock() {
        self.composeView.insertTextAtCurser("    ")
    }
    
//MARK: CodeViewDelegate Methods
    
    func textUpdated(text: String) {
        do {
            try self.previewWebView.loadHTMLString(MMMarkdown.HTMLStringWithMarkdown(text), baseURL: nil)
        } catch {
            print("failed to convert to HTML")
        }
        
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        let info = notification.userInfo
        let infoNSValue = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = infoNSValue.CGRectValue()
        let diff = self.view.bounds.height - keyboardRect.origin.y
        self.codeViewBottomOffSet.constant = diff
        
        UIView.animateWithDuration(0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.codeViewBottomOffSet.constant = 0
        
        UIView.animateWithDuration(0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func askForiCloud() {
        let alert: UIAlertController = UIAlertController(title: "Use iCloud?", message: "iCloud makes it easy to sync your documents with other devices", preferredStyle: .Alert)
        let whyNotAction: UIAlertAction = UIAlertAction(title: "Why not", style: .Default) { (action) in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.useiCloud)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.askedForiCloud)
            DocumentManager.sharedInstance.useiCloud = true
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        let noThanksAction: UIAlertAction = UIAlertAction(title: "No thanks", style: .Cancel) { (action) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: Constants.useiCloud)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.askedForiCloud)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        alert.addAction(noThanksAction)
        alert.addAction(whyNotAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//MARK: WebViewDelegate methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            let sfVC: SFSafariViewController = SFSafariViewController(URL: NSURL(string: (request.URL?.absoluteString)!)!)
            self.presentViewController(sfVC, animated: true, completion: nil)

            return false
        }
        return true
    }
    
//MARK: Keycommand methods
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "s", modifierFlags: .Command, action: #selector(save), discoverabilityTitle: "Save"),
            UIKeyCommand(input: "o", modifierFlags: .Command, action: #selector(open), discoverabilityTitle: "Open"),
            UIKeyCommand(input: "p", modifierFlags: [.Alternate, .Command], action: #selector(showPreview), discoverabilityTitle: "Preview Toggle"),
            UIKeyCommand(input: "+", modifierFlags: .Command, action: #selector(increaseFont), discoverabilityTitle: "Increase Font Size"),
            UIKeyCommand(input: "-", modifierFlags: .Command, action: #selector(decreaseFont), discoverabilityTitle: "Decrease Font Size")
            ]
    }
    
    func save() {
        if DocumentManager.sharedInstance.currentOpenDocument != nil {
            let parentView: ConmposeViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! ConmposeViewController
            let text: String = parentView.composeView.getText()
            DocumentManager.sharedInstance.saveWithName((DocumentManager.sharedInstance.currentOpenDocument?.fileURL.lastPathComponent!)!, data: text)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            weak var safeSelf = self
            let saveAsAlertController: UIAlertController = UIAlertController(title: "Save As", message: nil, preferredStyle: .Alert)
            saveAsAlertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Document Name"
            }
            let nameTextField: UITextField = saveAsAlertController.textFields![0]
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .Default) { (action) in
                if DocumentManager.sharedInstance.docNameAvailable(nameTextField.text!) {
                    let parentView: ConmposeViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! ConmposeViewController
                    let text: String = parentView.composeView.getText()
                    DocumentManager.sharedInstance.saveWithName(nameTextField.text!, data: text)
                    safeSelf!.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let invalideNameAlertController: UIAlertController = UIAlertController(title: "Invalid Name", message: "It looks like that name it taken. Try again?", preferredStyle: .Alert)
                    let nopeAction: UIAlertAction = UIAlertAction(title: "Nope", style: .Cancel, handler: nil)
                    let sureAction: UIAlertAction = UIAlertAction(title: "Sure", style: .Default, handler: { (action) in
                        safeSelf!.save()
                    })
                    invalideNameAlertController.addAction(nopeAction)
                    invalideNameAlertController.addAction(sureAction)
                    safeSelf!.presentViewController(invalideNameAlertController, animated: true, completion: nil)
                }
            }
            saveAsAlertController.addAction(cancelAction)
            saveAsAlertController.addAction(saveAction)
            safeSelf!.presentViewController(saveAsAlertController, animated: true, completion: nil)
        }
    }
    
    func open() {
        self.performSegueWithIdentifier(Constants.menuSegue, sender: self)
    }
    
    func increaseFont() {
        let fontSize: CGFloat = (self.composeView.getFont()?.pointSize)! + 1.0
        self.composeView.setfont(UIFont(name: "Hack", size: fontSize)!)
        
    }
    
    func decreaseFont() {
        let fontSize: CGFloat = (self.composeView.getFont()?.pointSize)! - 1.0
        self.composeView.setfont(UIFont(name: "Hack", size: fontSize)!)
    }
    
}
