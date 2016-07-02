//
//  OpenViewController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/5/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var availableDocuments: [String] = DocumentManager.sharedInstance.listAllDocuments()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: table view delegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableDocuments.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("documentCell")!
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "+ Create New Document"
        } else{
            cell.textLabel?.text = availableDocuments[indexPath.row - 1]
        }
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.useDarkmode) {
            cell.textLabel?.textColor = Constants.dayTimeBarColor
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectionIndex: Int = indexPath.row - 1
        let parentView: ConmposeViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! ConmposeViewController
        
        if selectionIndex < 0 {
            parentView.composeView.setText("")
            DocumentManager.sharedInstance.currentOpenDocument = nil
            parentView.composeView.textViewDidChange(UITextView())
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let selectedFileName = availableDocuments[selectionIndex]
            DocumentManager.sharedInstance.openDocumentWithName(selectedFileName)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.row > 0 {
            let renameAction: UITableViewRowAction = UITableViewRowAction(style: .Normal, title: "Rename", handler: { (action, indexPath) in
                let renameAlert: UIAlertController = UIAlertController(title: "Rename Document", message: "", preferredStyle: .Alert)
                renameAlert.addTextFieldWithConfigurationHandler { (textField) in
                    textField.placeholder = "New Name"
                }
                let newNameField = renameAlert.textFields![0]
                let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: .Cancel, handler: nil)
                let renameAlertAction: UIAlertAction = UIAlertAction(title: "Rename", style: .Default, handler: { (action) in
                    if DocumentManager.sharedInstance.docNameAvailable("\(newNameField.text!).md") && DocumentManager.sharedInstance.docNameAvailable(newNameField.text!) {
                        DocumentManager.sharedInstance.renameFileNamed(self.availableDocuments[indexPath.row - 1], newName: newNameField.text!)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        let failedAlert: UIAlertController = UIAlertController(title: "Failed to Rename", message: "The name provided was not available.", preferredStyle: .Alert)
                        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                        failedAlert.addAction(okAction)
                        self.presentViewController(failedAlert, animated: true, completion: nil)
                    }
                })
                renameAlert.addAction(cancelAction)
                renameAlert.addAction(renameAlertAction)
                
                self.presentViewController(renameAlert, animated: true, completion: nil)
            })
            
            let deleteAction: UITableViewRowAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
                DocumentManager.sharedInstance.deleteDocumentWithName(self.availableDocuments[indexPath.row - 1])
                self.availableDocuments.removeAtIndex(indexPath.row - 1)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            return [deleteAction, renameAction]
        } else {
            return nil
        }
    }
}
