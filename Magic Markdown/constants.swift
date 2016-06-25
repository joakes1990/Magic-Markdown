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
    
    //MARK: segue identifiers
    static let openSegue = "openSegue"
    static let menuSegue = "menuSegue"
    
    //MARK: NSNotifications
    static let askForiCloudnotification = "askForiCloud"
    static let saveSuccessful = "saveSuccessful"
    
    //MARK: Colors
    static let purpleColor: UIColor = UIColor(red: 0.443, green: 0.290, blue: 0.753, alpha: 1.00)
    static let redColor: UIColor = UIColor(red: 0.831, green: 0.196, blue: 0.122, alpha: 1.00)
    static let greenColor: UIColor = UIColor(red: 0.180, green: 0.518, blue: 0.184, alpha: 1.00)
    static let blueColor: UIColor = UIColor(red: 0.137, green: 0.282, blue: 0.898, alpha: 1.00)
}