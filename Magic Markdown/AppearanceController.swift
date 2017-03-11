//
//  AppearanceController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 7/2/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

class AppearanceController: NSObject {
    
    class func setLightMode() {
        
        UIToolbar.appearance().tintColor = Constants.dayTimeTint
        UITextView.appearance().backgroundColor = UIColor.white
        UITextField.appearance().backgroundColor = UIColor.white
        UIToolbar.appearance().barTintColor = Constants.dayTimeBarColor
        UISwitch.appearance().onTintColor = Constants.dayTimeTint
        UITableViewCell.appearance().backgroundColor = UIColor.white
        UITableView.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Constants.dayTimeBarColor
        UINavigationBar.appearance().tintColor = Constants.dayTimeTint
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.darkText], for: .disabled)
    }
    class func setDarkMode() {
        UIToolbar.appearance().tintColor = Constants.nightTimeTintColor
        UITextView.appearance().backgroundColor = UIColor.black
//        UITextField.appearance().backgroundColor = UIColor.blackColor()
        UIToolbar.appearance().barTintColor = Constants.nightTimeBarColor
        UISwitch.appearance().onTintColor = Constants.nightTimeTintColor
        UITableViewCell.appearance().backgroundColor = Constants.nightTimeBarColor
        UITableView.appearance().backgroundColor = Constants.nightTimeBarColor
        UINavigationBar.appearance().barTintColor = Constants.nightTimeBarColor
        UINavigationBar.appearance().tintColor = Constants.nightTimeTintColor
    }
}
