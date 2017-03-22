//
//  ExportViewController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 3/21/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menuOptions: [String] = ["Export MD", "Export HTML", "Export PDF"]
    unowned let unownedParent: ConmposeViewController = UIApplication.shared.keyWindow!.rootViewController as! ConmposeViewController
        
    override func viewWillAppear(_ animated: Bool) {
        let size: CGSize = CGSize(width: 320, height: 320); // size of view in popover
        self.preferredContentSize = size;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareOpenDocument(activityItems: [URL]) {
        
        let actionView: UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        actionView.popoverPresentationController?.barButtonItem = unownedParent.actionButton
        self.present(actionView, animated: true, completion: nil)
        
    }
    //MARK: TableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "exportCell", for: indexPath)
        cell.textLabel?.text = self.menuOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check fpr open doc
        if DocumentManager.sharedInstance.currentOpenDocument == nil {
            let alert: UIAlertController = UIAlertController(title: "No Document Open", message: "No Document is currently open. Please save this one or open an existing one to share with the share sheet", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: { 
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
        switch indexPath.row {
        case 0:
            let openDocURL = DocumentManager.sharedInstance.currentOpenDocument?.fileURL
            shareOpenDocument(activityItems: [openDocURL!])
            break
        default:
            break
        }
    }
}
