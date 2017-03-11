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

    let menuOptions: [String] = ["Document Management", "Save", "Settings", "Markdown Reference"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let size: CGSize = CGSize(width: 320, height: 320); // size of view in popover
        self.preferredContentSize = size;
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .phone {
            let dismissButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
            self.navigationItem.setRightBarButton(dismissButton, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        cell.textLabel?.text = self.menuOptions[indexPath.row]
        if UserDefaults.standard.bool(forKey: Constants.useDarkmode) {
            cell.textLabel?.textColor = Constants.dayTimeBarColor
        } else {
            cell.textLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: Constants.openSegue, sender: self)
            break
        case 1:
            self.saveOpenDocument()
            break
        case 2:
            self.performSegue(withIdentifier: Constants.settingsSegue, sender: self)
            break
        case 3:
            self.displayReference()
            break
        default:
            print("somthing else pressed")
            break
        }
    }
    
    func saveOpenDocument() {
        if DocumentManager.sharedInstance.currentOpenDocument != nil {
            weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
            let text: String = parentView!.composeView.getText()
            DocumentManager.sharedInstance.saveWithName((DocumentManager.sharedInstance.currentOpenDocument?.fileURL.lastPathComponent)!, data: text)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.saveAs()
        }
    }
    
    func saveAs() {
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
                    safeSelf!.saveAs()
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
    
    func displayReference() {
        let sfVC: SFSafariViewController = SFSafariViewController(url: URL(string: "https://daringfireball.net/projects/markdown/")!)
        self.present(sfVC, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if newCollection.horizontalSizeClass == .compact {
            let dismissButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
            self.navigationItem.setRightBarButton(dismissButton, animated: true)
        }
    }
}
