//
//  ConmposeViewController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 5/16/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit
import OKSGutteredCodeView


class ConmposeViewController: UIViewController, CodeViewDelegate, UIWebViewDelegate {

    @IBOutlet weak var composeView: OKSGutteredCodeView!
    @IBOutlet weak var previewWebView: UIWebView!
    @IBOutlet weak var previewWidth: NSLayoutConstraint!
    var previewVisable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //composeview set up
        self.composeView.setfont(UIFont(name: "Hack", size: 17.0)!)
        self.composeView.delegate = self
        
        if !DocumentController.appHasBeenOpen() {
            self.composeView.setText(DocumentController.defaultString())
        }
        //Keyboard toolbar set up
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 70))
        
        let quoteButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "quote3x"), style: .Plain, target: self, action: #selector(addQuote))
        let linkButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Link3x"), style: .Plain, target: self, action: #selector(addLink))
        let imageButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Image3x"), style: .Plain, target: self, action: #selector(addImage))
        let codeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Code3x"), style: .Plain, target: self, action: #selector(addCodeBlock))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixedSpace.width = 40
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
    
//MARK: WebViewDelegate methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}
