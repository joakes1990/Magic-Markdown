//
//  DocumentManager.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/4/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

class DocumentManager: NSObject {
    
    static let sharedInstance: DocumentManager = DocumentManager()
    
    var documents: [MarkdownDocument] = []
    var currentOpenDocument: MarkdownDocument?
    
    class func iCloudAvailable() -> Bool {
        return false
    }
    
    class func appHasBeenOpen() -> Bool {
        let opened: Bool? = NSUserDefaults.standardUserDefaults().boolForKey(Constants.previouslyRanDefault)
        if opened != nil {
            return true
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.previouslyRanDefault)
            NSUserDefaults.standardUserDefaults().synchronize()
            return false
        }
    }
    
    class func defaultString() -> String {
        return NSBundle.mainBundle().pathForResource("firstRun", ofType: "md")!
    }
    
    class func previousDocumentAvailable() -> Bool {
        //TODO: Actually check for this later
        return false
    }
    
    func docNameAvailable(name: String) -> Bool {
        var nameAvailable: Bool = false
        for doc: MarkdownDocument in self.documents {
            if doc.fileURL.lastPathComponent == name {
                nameAvailable = true
            }
        }
        return nameAvailable
    }

}
