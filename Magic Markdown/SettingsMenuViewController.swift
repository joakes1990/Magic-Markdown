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
        weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
        self.fontSizeLabel.text = "\(parentView!.composeView.getFont()!.pointSize)"
        self.fontSizeStepper.value = Double((parentView?.composeView.getFont()?.pointSize)!)
        self.saveOnExitSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.saveOnExit)
        self.darkmodeSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.useDarkmode)
        if UserDefaults.standard.bool(forKey: Constants.useDarkmode) {
            self.fontLabel.textColor = Constants.dayTimeBarColor
            self.autoSaveLabel.textColor = Constants.dayTimeBarColor
            self.darkModeLabel.textColor = Constants.dayTimeBarColor
            self.view.backgroundColor = Constants.nightTimeBarColor
            self.fontSizeLabel.textColor = Constants.dayTimeBarColor
            self.fontSizeStepper.tintColor = Constants.nightTimeTintColor
            self.saveOnExitSwitch.onTintColor = Constants.nightTimeTintColor
            self.darkmodeSwitch.onTintColor = Constants.nightTimeTintColor
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            let dismissButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissViewController))
            self.navigationItem.setRightBarButton(dismissButton, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changeSize(_ sender: AnyObject) {
        weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
        self.fontSizeLabel.text = "\(self.fontSizeStepper.value)"
        let newFont: UIFont = UIFont(name:  ((parentView?.composeView.getFont())?.fontName)!, size: CGFloat(self.fontSizeStepper.value))!
        parentView?.composeView.setfont(newFont)
        UserDefaults.standard.set(self.fontSizeStepper.value, forKey: Constants.fontSize)
        UserDefaults.standard.synchronize()
    }


    @IBAction func toggleSaveOnExit(_ sender: AnyObject) {
        UserDefaults.standard.set(self.saveOnExitSwitch.isOn, forKey: Constants.saveOnExit)
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func toggleDarkMode(_ sender: AnyObject) {
        UserDefaults.standard.set(self.darkmodeSwitch.isOn, forKey: Constants.useDarkmode)
        UserDefaults.standard.synchronize()
        if self.darkmodeSwitch.isOn {
            weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
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
            weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
            AppearanceController.setLightMode()
            parentView?.setBarColor()
            self.view.backgroundColor = UIColor.white
            self.fontSizeLabel.textColor = UIColor.black
            self.fontSizeStepper.tintColor = Constants.dayTimeTint
            self.saveOnExitSwitch.onTintColor = Constants.dayTimeTint
            self.darkmodeSwitch.onTintColor = Constants.dayTimeTint
            self.navigationController?.navigationBar.barTintColor = Constants.dayTimeBarColor
            self.navigationController?.navigationBar.tintColor = Constants.dayTimeTint
            self.fontLabel.textColor = UIColor.black
            self.autoSaveLabel.textColor = UIColor.black
            self.darkModeLabel.textColor = UIColor.black
        }
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
