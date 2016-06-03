//
//  DocumentController.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/2/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

public class DocumentController: NSObject {
    
    var openDocument: Document?
    
    class func appHasBeenOpen() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey(Constants.previouslyRanDefault) {
            return true
        } else {
            userDefaults.setBool(true, forKey: Constants.previouslyRanDefault)
            userDefaults.synchronize()
            return false
        }
    }
    
    class func defaultString() -> String {
        let firstRunMDPath: String = NSBundle.mainBundle().pathForResource("firstRun", ofType: "md")!
        let firstRunMDURL: NSURL = NSURL(fileURLWithPath: firstRunMDPath)
        
        do {
            let textString: String =  try String(contentsOfURL: firstRunMDURL, encoding: NSUTF8StringEncoding)
            return textString
        } catch {
            print("failed to retreive text from MD file")
            return "Thanks for downloading Magic Markdown"
        }
        
        
    }
    
    class func previousDocumentAvailable() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.stringForKey(Constants.previouslyOpenDocument) != nil) {
            //see if available
            return true
        } else {
            return false
        }
    }

}
