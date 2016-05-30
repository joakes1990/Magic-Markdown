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

    let menuOptions: [String] = ["Settings", "Markdown Reference", "Save", "Rename"]
    
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
            print("0 pressed")
            break
        case 1:
            self.displayReference()
            break
        default:
            print("somthing else pressed")
            break
        }
    }
    func displayReference() {
        let sfVC: SFSafariViewController = SFSafariViewController(URL: NSURL(string: "https://daringfireball.net/projects/markdown/")!)
        self.presentViewController(sfVC, animated: true, completion: nil)
    }
}
