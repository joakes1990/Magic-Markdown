//
//  constants.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/2/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import Foundation

struct Constants {
    
    //MARK: user defaults
    static let previouslyRanDefault = "previouslyRan"
    static let previouslyOpenDocument = "previousDocumentName"
    static let useiCloud = "useiCloud"
    static let askedForiCloud = "askedForiCloud"
    static let fontSize = "fontSize"
    static let saveOnExit = "saveOnExit"
    static let useDarkmode = "useDarkMode"
    
    //MARK: segue identifiers
    static let openSegue = "openSegue"
    static let menuSegue = "menuSegue"
    static let settingsSegue = "settingsSegue"
    
    //MARK: NSNotifications
    static let askForiCloudnotification = "askForiCloud"
    static let saveSuccessful = "saveSuccessful"
    static let documentsReady = "documentsReady"
    
    //MARK: file names
    static let trash = ".Trash"
    static let iCloudExtention = ".icloud"
    
    //MARK: Colors
    static let purpleColor: UIColor = UIColor(red: 0.686, green: 0.427, blue: 0.796, alpha: 1.00)
    static let redColor: UIColor = UIColor(red: 0.831, green: 0.196, blue: 0.122, alpha: 1.00)
    static let greenColor: UIColor = UIColor(red: 0.529, green: 0.820, blue: 0.094, alpha: 1.00)
    static let blueColor: UIColor = UIColor(red: 0.137, green: 0.282, blue: 0.898, alpha: 1.00)
    static let dayTimeBarColor: UIColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.00)
    static let dayTimeTint: UIColor = UIColor(red: 1.000, green: 0.753, blue: 0.165, alpha: 1.00)
    static let nightTimeBarColor: UIColor = UIColor(red: 0.357, green: 0.376, blue: 0.451, alpha: 1.00)
    static let nightTimeTintColor: UIColor = UIColor(red: 0.608, green: 0.820, blue: 0.800, alpha: 1.00)
}
