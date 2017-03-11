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
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var titleLabel: UIBarButtonItem!
    
    var previewVisable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //composeview set up
        NotificationCenter.default.addObserver(self, selector: #selector(askForiCloud), name: NSNotification.Name(rawValue: Constants.askForiCloudnotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveSuccess), name: NSNotification.Name(rawValue: Constants.saveSuccessful), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openDoc), name: NSNotification.Name(rawValue: Constants.documentsReady), object: nil)
        DocumentManager.sharedInstance.listAllDocuments()
        let fontSize = UserDefaults.standard.object(forKey: Constants.fontSize) != nil ? UserDefaults.standard.double(forKey: Constants.fontSize) : 15.0
        self.composeView.setfont(UIFont(name: "Hack", size: CGFloat(fontSize))!)
        self.composeView.delegate = self
        self.setBarColor()
        self.previewWebView.layer.borderWidth = 1.0
        self.previewWebView.layer.borderColor = UIColor(red: 0.561, green: 0.584, blue: 0.588, alpha: 1.00).cgColor
        
        self.titleLabel.isEnabled = false
        if !DocumentManager.appHasBeenOpen() {
            self.composeView.setText(DocumentManager.defaultString())
        } else {
            self.composeView.setText("")
        }
        //Keyboard toolbar set up
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        
        let quoteButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "quote3x"), style: .plain, target: self, action: #selector(addQuote))
        let linkButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Link3x"), style: .plain, target: self, action: #selector(addLink))
        let imageButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Image3x"), style: .plain, target: self, action: #selector(addImage))
        let codeButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Code3x"), style: .plain, target: self, action: #selector(addCodeBlock))
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let fixedSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 15 : 50
        toolbar.items = [flexSpace, quoteButton, fixedSpace, linkButton, fixedSpace, imageButton, fixedSpace, codeButton, flexSpace]
        
        self.composeView.addTextViewAccessoryView(toolbar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titleLabel.title = DocumentManager.sharedInstance.currentOpenDocument != nil ? DocumentManager.sharedInstance.currentOpenDocument!.fileURL.lastPathComponent : "Untitled Document"
        self.setBarColor()
        DispatchQueue.global().async {
            DocumentManager.sharedInstance.checkforiCloud()
        }
    }
    
    func openDoc() {
        if DocumentManager.previousDocumentAvailable() {
            DocumentManager.sharedInstance.openDocumentWithName(UserDefaults.standard.string(forKey: Constants.previouslyOpenDocument)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPreview(_ sender: AnyObject) {
        if self.previewVisable {
            self.previewVisable = false
            self.previewWidth.constant = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.previewVisable = true
            self.previewWidth.constant = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact ? self.view.bounds.width - 1 : self.view.bounds.width / 2
            UIView.animate(withDuration: 0.5, animations: { 
                self.view.layoutIfNeeded()
            })
        }
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if self.previewVisable {
            self.perform(#selector(rotatePreview), with: nil, afterDelay: 0.25)
            
        }
    }

    func rotatePreview() {
        self.previewWidth.constant = self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact ? self.view.bounds.width : self.view.bounds.width / 2

    }
    
    func saveSuccess() {
        self.view.makeToast("Save Successful")
    }
    
    func setBarColor() {
        if UserDefaults.standard.bool(forKey: Constants.useDarkmode) {
            self.composeView.setGutterBackgroundColor(Constants.nightTimeBarColor)
            self.composeView.addFontColor(Constants.dayTimeBarColor)
            self.composeView.setTextViewBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            self.composeView.textViewDidChange(UITextView())
            self.view.backgroundColor = UIColor.black
            self.toolBar.barTintColor = Constants.nightTimeBarColor
            self.toolBar.tintColor = Constants.nightTimeTintColor
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            self.composeView.setGutterBackgroundColor(Constants.dayTimeBarColor)
            self.composeView.addFontColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            self.composeView.setTextViewBackgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            self.composeView.textViewDidChange(UITextView())
            self.view.backgroundColor = UIColor.white
            self.toolBar.barTintColor = Constants.dayTimeBarColor
            self.toolBar.tintColor = Constants.dayTimeTint
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
//MARK: insertion methods
    
    func addQuote() {
        self.composeView.insertTextAtCurser(">")
    }
    
    func addLink() {
        let alertView: UIAlertController = UIAlertController(title: "New Link", message: nil, preferredStyle: .alert)
        
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Alt Text"
            textfield.backgroundColor = UIColor.white
        }
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Link URL"
            textfield.backgroundColor = UIColor.white
        }
        
        let altTextField = alertView.textFields![0] as UITextField
        let LinkTextField = alertView.textFields![1] as UITextField

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let insertAction = UIAlertAction(title: "Insert", style: .default) { (action) in
            if LinkTextField.text! != "" {
                self.composeView.insertTextAtCurser("[\(altTextField.text! != "" ? altTextField.text! : "Click here")](\(LinkTextField.text!))")
            }
        }
        alertView.addAction(cancelAction)
        alertView.addAction(insertAction)

        self.present(alertView, animated: true) { 
            
        }
    }
    
    func addImage() {
        let alertView: UIAlertController = UIAlertController(title: "New Image", message: nil, preferredStyle: .alert)
        
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Alt Text"
            textfield.backgroundColor = UIColor.white
        }
        alertView.addTextField { (textfield) in
            textfield.placeholder = "Image URL"
            textfield.backgroundColor = UIColor.white
        }
        
        let altTextField = alertView.textFields![0] as UITextField
        let LinkTextField = alertView.textFields![1] as UITextField
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        let insertAction = UIAlertAction(title: "Insert", style: .default) { (action) in
            if LinkTextField.text! != "" {
                self.composeView.insertTextAtCurser("![\(altTextField.text! != "" ? altTextField.text! : "Click here")](\(LinkTextField.text!))")
            }
        }
        alertView.addAction(cancelAction)
        alertView.addAction(insertAction)
        
        self.present(alertView, animated: true) {
            
        }
    }
    
    func addCodeBlock() {
        self.composeView.insertTextAtCurser("    ")
    }
    
//MARK: CodeViewDelegate Methods
    
    func textUpdated(_ text: String) {
        self.highlightText()
        do {
            try self.previewWebView.loadHTMLString(MMMarkdown.htmlString(withMarkdown: text), baseURL: nil)
        } catch {
            print("failed to convert to HTML")
        }
        
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        let info = notification.userInfo
        let infoNSValue = info![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = infoNSValue.cgRectValue
        let diff = self.view.bounds.height - keyboardRect.origin.y
        self.codeViewBottomOffSet.constant = diff
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.view.layoutIfNeeded()
        }) 
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.codeViewBottomOffSet.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    func askForiCloud() {
        let alert: UIAlertController = UIAlertController(title: "Use iCloud?", message: "iCloud makes it easy to sync your documents with other devices", preferredStyle: .alert)
        let whyNotAction: UIAlertAction = UIAlertAction(title: "Why not", style: .default) { (action) in
            UserDefaults.standard.set(true, forKey: Constants.useiCloud)
            UserDefaults.standard.set(true, forKey: Constants.askedForiCloud)
            DocumentManager.sharedInstance.useiCloud = true
            UserDefaults.standard.synchronize()
        }
        let noThanksAction: UIAlertAction = UIAlertAction(title: "No thanks", style: .cancel) { (action) in
            UserDefaults.standard.set(false, forKey: Constants.useiCloud)
            UserDefaults.standard.set(true, forKey: Constants.askedForiCloud)
            UserDefaults.standard.synchronize()
        }
        
        alert.addAction(noThanksAction)
        alert.addAction(whyNotAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
//MARK: WebViewDelegate methods
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            let sfVC: SFSafariViewController = SFSafariViewController(url: URL(string: (request.url?.absoluteString)!)!)
            self.present(sfVC, animated: true, completion: nil)

            return false
        }
        return true
    }
    
//MARK: Keycommand methods
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: "s", modifierFlags: .command, action: #selector(save), discoverabilityTitle: "Save"),
            UIKeyCommand(input: "o", modifierFlags: .command, action: #selector(open), discoverabilityTitle: "Open"),
            UIKeyCommand(input: "p", modifierFlags: [.alternate, .command], action: #selector(showPreview), discoverabilityTitle: "Preview Toggle"),
            UIKeyCommand(input: "+", modifierFlags: .command, action: #selector(increaseFont), discoverabilityTitle: "Increase Font Size"),
            UIKeyCommand(input: "-", modifierFlags: .command, action: #selector(decreaseFont), discoverabilityTitle: "Decrease Font Size")
            ]
    }
    
    func save() {
        if DocumentManager.sharedInstance.currentOpenDocument != nil {
            let parentView: ConmposeViewController = UIApplication.shared.keyWindow!.rootViewController as! ConmposeViewController
            let text: String = parentView.composeView.getText()
            DocumentManager.sharedInstance.saveWithName((DocumentManager.sharedInstance.currentOpenDocument?.fileURL.lastPathComponent)!, data: text)
            self.dismiss(animated: true, completion: nil)
        } else {
            weak var safeSelf = self
            let saveAsAlertController: UIAlertController = UIAlertController(title: "Save As", message: nil, preferredStyle: .alert)
            saveAsAlertController.addTextField { (textField) in
                textField.placeholder = "Document Name"
            }
            let nameTextField: UITextField = saveAsAlertController.textFields![0]
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction: UIAlertAction = UIAlertAction(title: "Save", style: .default) { (action) in
                if DocumentManager.sharedInstance.docNameAvailable(nameTextField.text!) {
                    let parentView: ConmposeViewController = UIApplication.shared.keyWindow!.rootViewController as! ConmposeViewController
                    let text: String = parentView.composeView.getText()
                    DocumentManager.sharedInstance.saveWithName(nameTextField.text!, data: text)
                    safeSelf!.dismiss(animated: true, completion: nil)
                } else {
                    let invalideNameAlertController: UIAlertController = UIAlertController(title: "Invalid Name", message: "It looks like that name it taken. Try again?", preferredStyle: .alert)
                    let nopeAction: UIAlertAction = UIAlertAction(title: "Nope", style: .cancel, handler: nil)
                    let sureAction: UIAlertAction = UIAlertAction(title: "Sure", style: .default, handler: { (action) in
                        safeSelf!.save()
                    })
                    invalideNameAlertController.addAction(nopeAction)
                    invalideNameAlertController.addAction(sureAction)
                    safeSelf!.present(invalideNameAlertController, animated: true, completion: nil)
                }
            }
            saveAsAlertController.addAction(cancelAction)
            saveAsAlertController.addAction(saveAction)
            safeSelf!.present(saveAsAlertController, animated: true, completion: nil)
        }
    }
    
    func open() {
        self.performSegue(withIdentifier: Constants.menuSegue, sender: self)
    }
    
    func increaseFont() {
        let fontSize: CGFloat = (self.composeView.getFont()?.pointSize)! + 1.0
        self.composeView.setfont(UIFont(name: "Hack", size: fontSize)!)
        UserDefaults.standard.set(Double(fontSize), forKey: Constants.fontSize)
        UserDefaults.standard.synchronize()
        
    }
    
    func decreaseFont() {
        let fontSize: CGFloat = (self.composeView.getFont()?.pointSize)! - 1.0
        self.composeView.setfont(UIFont(name: "Hack", size: fontSize)!)
        UserDefaults.standard.set(Double(fontSize), forKey: Constants.fontSize)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: highlighting methods
    
    func highlightText() {
        let attributes = ["#" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.purpleColor],
                          "=" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.redColor],
                          "_" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.redColor],
                          "*" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.greenColor],
                          "!" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.blueColor],
                          "[" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.blueColor],
                          "]" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.blueColor],
                          "(" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.blueColor],
                          ")" : [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName: Constants.blueColor]]
        let text: String = self.composeView.getText()
        let attributedText : NSMutableAttributedString = NSMutableAttributedString()
        for char in text.characters {
            let charString = String(char)
            if attributes[charString] != nil {
                attributedText.append(NSMutableAttributedString(string: charString, attributes: (attributes[charString]! as [String : NSObject])))
            } else {
                attributedText.append(NSAttributedString(string: charString, attributes: [NSFontAttributeName : self.composeView.getFont()!, NSForegroundColorAttributeName : UserDefaults.standard.bool(forKey: Constants.useDarkmode) ? Constants.dayTimeBarColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]))
            }
        }
        self.composeView.setAttributedText(attributedText)
    }
    
    //MARK: sharing
    
    @IBAction func shareOpenDocument(_ sender: AnyObject) {
        if DocumentManager.sharedInstance.currentOpenDocument == nil {
            let alert: UIAlertController = UIAlertController(title: "No Document Open", message: "No Document is currently open. Please save this one or open an existing one to share with the share sheet", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let activityItems: [URL] = [(DocumentManager.sharedInstance.currentOpenDocument?.fileURL)!]
            let actionView: UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            actionView.popoverPresentationController?.barButtonItem = self.actionButton
            self.present(actionView, animated: true, completion: nil)
        }
    }
    
    
}
