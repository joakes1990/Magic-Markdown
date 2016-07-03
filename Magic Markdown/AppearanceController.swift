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
        UITextView.appearance().backgroundColor = UIColor.whiteColor()
        UITextField.appearance().backgroundColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = Constants.dayTimeBarColor
        UISwitch.appearance().onTintColor = Constants.dayTimeTint
        UITableViewCell.appearance().backgroundColor = UIColor.whiteColor()
        UITableView.appearance().backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = Constants.dayTimeBarColor
        UINavigationBar.appearance().tintColor = Constants.dayTimeTint
    }
    class func setDarkMode() {
        UIToolbar.appearance().tintColor = Constants.nightTimeTintColor
        UITextView.appearance().backgroundColor = UIColor.blackColor()
//        UITextField.appearance().backgroundColor = UIColor.blackColor()
        UIToolbar.appearance().barTintColor = Constants.nightTimeBarColor
        UISwitch.appearance().onTintColor = Constants.nightTimeTintColor
        UITableViewCell.appearance().backgroundColor = Constants.nightTimeBarColor
        UITableView.appearance().backgroundColor = Constants.nightTimeBarColor
        UINavigationBar.appearance().barTintColor = Constants.nightTimeBarColor
        UINavigationBar.appearance().tintColor = Constants.nightTimeTintColor
        
    }
}