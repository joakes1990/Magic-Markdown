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
        // Do any additional setup after loading the view.
        
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
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectionIndex: Int = indexPath.row - 1
        let parentView: ConmposeViewController = UIApplication.sharedApplication().keyWindow!.rootViewController as! ConmposeViewController
        
        if selectionIndex < 0 {
            parentView.composeView.setText("")
            DocumentManager.sharedInstance.currentOpenDocument = nil
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            DocumentManager.sharedInstance.deleteDocumentWithName(availableDocuments[indexPath.row - 1])
            self.availableDocuments.removeAtIndex(indexPath.row - 1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
}
