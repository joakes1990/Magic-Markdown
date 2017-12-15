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
        if UIDevice.current.userInterfaceIdiom == .phone {
            let dismissButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
            self.navigationItem.setRightBarButton(dismissButton, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: table view delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableDocuments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "documentCell")!
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "+ Create New Document"
        } else{
            cell.textLabel?.text = availableDocuments[indexPath.row - 1]
        }
        if UserDefaults.standard.bool(forKey: Constants.useDarkmode) {
            cell.textLabel?.textColor = Constants.dayTimeBarColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectionIndex: Int = indexPath.row - 1
        let parentView: ConmposeViewController = UIApplication.shared.keyWindow!.rootViewController as! ConmposeViewController
        
        if selectionIndex < 0 {
            parentView.composeView.setText("")
            DocumentManager.sharedInstance.currentOpenDocument = nil
            parentView.composeView.textViewDidChange(UITextView())
            parentView.titleLabel.title = "Untitled Document"
            self.dismiss(animated: true, completion: nil)
        } else {
            let selectedFileName = availableDocuments[selectionIndex]
            DocumentManager.sharedInstance.openDocumentWithName(selectedFileName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row > 0 {
            let renameAction: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Rename", handler: { (action, indexPath) in
                let renameAlert: UIAlertController = UIAlertController(title: "Rename Document", message: "", preferredStyle: .alert)
                renameAlert.addTextField { (textField) in
                    textField.placeholder = "New Name"
                }
                let newNameField = renameAlert.textFields![0]
                let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                let renameAlertAction: UIAlertAction = UIAlertAction(title: "Rename", style: .default, handler: { (action) in
                    if DocumentManager.sharedInstance.docNameAvailable("\(newNameField.text!).md") && DocumentManager.sharedInstance.docNameAvailable(newNameField.text!) {
                        DocumentManager.sharedInstance.renameFileNamed(self.availableDocuments[indexPath.row - 1], newName: newNameField.text!)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        let failedAlert: UIAlertController = UIAlertController(title: "Failed to Rename", message: "The name provided was not available.", preferredStyle: .alert)
                        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        failedAlert.addAction(okAction)
                        self.present(failedAlert, animated: true, completion: nil)
                    }
                })
                renameAlert.addAction(cancelAction)
                renameAlert.addAction(renameAlertAction)
                
                self.present(renameAlert, animated: true, completion: nil)
            })
            
            let deleteAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                DocumentManager.sharedInstance.deleteDocumentWithName(self.availableDocuments[indexPath.row - 1])
                self.availableDocuments.remove(at: indexPath.row - 1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            return [deleteAction, renameAction]
        } else {
            return nil
        }
    }
}
