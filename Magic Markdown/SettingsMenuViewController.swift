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
    @IBOutlet weak var saveOnExitSwitch: UISwitch!
    @IBOutlet weak var darkmodeSwitch: UISwitch!
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var autoSaveLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
        self.fontSizeLabel.text = "\(parentView!.composeView.getFont()!.pointSize)"
        self.fontSizeStepper.value = Double((parentView?.composeView.getFont()?.pointSize)!)
        self.saveOnExitSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(Constants.saveOnExit)
        self.darkmodeSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(Constants.useDarkmode)
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.useDarkmode) {
            self.fontLabel.textColor = Constants.dayTimeBarColor
            self.autoSaveLabel.textColor = Constants.dayTimeBarColor
            self.darkModeLabel.textColor = Constants.dayTimeBarColor
            self.view.backgroundColor = Constants.nightTimeBarColor
            self.fontSizeLabel.textColor = Constants.dayTimeBarColor
            self.fontSizeStepper.tintColor = Constants.nightTimeTintColor
            self.saveOnExitSwitch.onTintColor = Constants.nightTimeTintColor
            self.darkmodeSwitch.onTintColor = Constants.nightTimeTintColor
        }
        if self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Compact {
            let dismissButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(dismissViewController))
            self.navigationItem.setRightBarButtonItem(dismissButton, animated: true)
        }
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


    @IBAction func toggleSaveOnExit(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(self.saveOnExitSwitch.on, forKey: Constants.saveOnExit)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func toggleDarkMode(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(self.darkmodeSwitch.on, forKey: Constants.useDarkmode)
        NSUserDefaults.standardUserDefaults().synchronize()
        if self.darkmodeSwitch.on {
            weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
            AppearanceController.setDarkMode()
            parentView?.setBarColor()
            self.view.backgroundColor = Constants.nightTimeBarColor
            self.fontSizeLabel.textColor = Constants.dayTimeBarColor
            self.fontSizeStepper.tintColor = Constants.nightTimeTintColor
            self.saveOnExitSwitch.onTintColor = Constants.nightTimeTintColor
            self.darkmodeSwitch.onTintColor = Constants.nightTimeTintColor
            self.navigationController?.navigationBar.barTintColor = Constants.nightTimeBarColor
            self.navigationController?.navigationBar.tintColor = Constants.nightTimeTintColor
            self.fontLabel.textColor = Constants.dayTimeBarColor
            self.autoSaveLabel.textColor = Constants.dayTimeBarColor
            self.darkModeLabel.textColor = Constants.dayTimeBarColor
            
        } else {
            weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
            AppearanceController.setLightMode()
            parentView?.setBarColor()
            self.view.backgroundColor = UIColor.whiteColor()
            self.fontSizeLabel.textColor = UIColor.blackColor()
            self.fontSizeStepper.tintColor = Constants.dayTimeTint
            self.saveOnExitSwitch.onTintColor = Constants.dayTimeTint
            self.darkmodeSwitch.onTintColor = Constants.dayTimeTint
            self.navigationController?.navigationBar.barTintColor = Constants.dayTimeBarColor
            self.navigationController?.navigationBar.tintColor = Constants.dayTimeTint
            self.fontLabel.textColor = UIColor.blackColor()
            self.autoSaveLabel.textColor = UIColor.blackColor()
            self.darkModeLabel.textColor = UIColor.blackColor()
        }
    }
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
