//
//  MenuViewController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 5/29/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit
import SafariServices

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuOptions: [String] = ["Open", "Save", "Rename", "New Document", "Settings", "Markdown Reference"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let size: CGSize = CGSizeMake(320, 320); // size of view in popover
        self.preferredContentSize = size;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
        cell.textLabel?.text = self.menuOptions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier(Constants.openSegue, sender: self)
            break
        case 1:
            self.saveOpenDocument()
            break
        case 2:
            print("2 pressed")
            break
        case 3:
            print("3 pressed")
            break
        case 4:
            print("4 pressed")
            break
        case 5:
            self.displayReference()
            break
        default:
            print("somthing else pressed")
            break
        }
    }
    
    func saveOpenDocument() {
        if DocumentManager.sharedInstance.currentOpenDocument != nil {
            let parentView: ConmposeViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! ConmposeViewController
            let text: String = parentView.composeView.getText()
            DocumentManager.sharedInstance.saveWithName((DocumentManager.sharedInstance.currentOpenDocument?.fileURL.lastPathComponent!)!, data: text)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.saveAs()
        }
    }
    
    func saveAs() {
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
                    safeSelf!.saveAs()
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
    
    func displayReference() {
        let sfVC: SFSafariViewController = SFSafariViewController(URL: NSURL(string: "https://daringfireball.net/projects/markdown/")!)
        self.presentViewController(sfVC, animated: true, completion: nil)
    }
    
        
}
