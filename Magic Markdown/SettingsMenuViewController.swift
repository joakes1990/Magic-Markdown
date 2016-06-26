//
//  SettingsMenuViewController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/26/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

class SettingsMenuViewController: UIViewController {

    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
        self.fontSizeLabel.text = "\(parentView!.composeView.getFont()!.pointSize)"
        self.fontSizeStepper.value = Double((parentView?.composeView.getFont()?.pointSize)!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changeSize(sender: AnyObject) {
        weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
        self.fontSizeLabel.text = "\(self.fontSizeStepper.value)"
        let newFont: UIFont = UIFont(name:  ((parentView?.composeView.getFont())?.fontName)!, size: CGFloat(self.fontSizeStepper.value))!
        parentView?.composeView.setfont(newFont)
        NSUserDefaults.standardUserDefaults().setDouble(self.fontSizeStepper.value, forKey: Constants.fontSize)
        NSUserDefaults.standardUserDefaults().synchronize()
    }


}
