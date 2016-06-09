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
    
    override init() {
        super.init()
        
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.useiCloud) {
            //TODO: do iCloud stuff
        
        } else {
            let docNames: [String] = self.listAllDocuments()
            for name: String in docNames {
                let document: MarkdownDocument = MarkdownDocument(fileURL: self.getDocURL(name))
                self.documents.append(document)
            }
        }
    }
    
    class func iCloudAvailable() -> Bool {
        return false
    }
    
    class func appHasBeenOpen() -> Bool {
        let opened: Bool? = NSUserDefaults.standardUserDefaults().boolForKey(Constants.previouslyRanDefault)
        if opened != nil && opened == true {
            return true
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Constants.previouslyRanDefault)
            NSUserDefaults.standardUserDefaults().synchronize()
            return false
        }
    }
    
    class func defaultString() -> String {
        do {
            return try String(contentsOfFile: NSBundle.mainBundle().pathForResource("firstRun", ofType: "md")!)
        } catch {
            print("failed to read file from bundel")
            return ""
        }
        
    }
    
    class func previousDocumentAvailable() -> Bool {
        let previousDocumentName = NSUserDefaults.standardUserDefaults().stringForKey(Constants.previouslyOpenDocument)
        if previousDocumentName != nil && !DocumentManager.sharedInstance.docNameAvailable(previousDocumentName!) {
            return true
        } else {
            return false
        }
    }
    
    func docNameAvailable(name: String) -> Bool {
        var nameAvailable: Bool = true
        for doc: MarkdownDocument in self.documents {
            if doc.fileURL.lastPathComponent == name {
                nameAvailable = false
            }
        }
        return nameAvailable
    }
    
    func getDocURL(name: String) -> NSURL {
        if DocumentManager.iCloudAvailable() {
            //TODO: Handel geting icloud url
            return NSURL()
        } else {
            return name.substringFromIndex(name.startIndex.advancedBy(name.characters.count - 3)) == ".md" ? NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0].URLByAppendingPathComponent(name) : NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0].URLByAppendingPathComponent(name).URLByAppendingPathExtension("md")
        }
    }
    
    //MARK: opening
    
    func listAllDocuments() -> [String] {
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.useiCloud) {
           //TODO: do iCloud stuff
            return []
        } else {
            var files: [String] = []
            let fileManager: NSFileManager = NSFileManager.defaultManager()
            let docsDirURL: NSURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            do {
                files = try fileManager.contentsOfDirectoryAtPath(docsDirURL.path!)
            } catch {
                print("No documents found")
            }
            return files
        }
    }
    
    func openDocumentWithName(name: String) {
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.useiCloud) {
            //TODO: do iCloud stuff
            
        } else {
            let fileURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0].URLByAppendingPathComponent(name)
            let mardownDocument: MarkdownDocument = MarkdownDocument(fileURL: fileURL)
            mardownDocument.openWithCompletionHandler({ (success) in
                if !success {
                    print("failed to open")
                    return
                }
                let stringData = mardownDocument.text != nil ? mardownDocument.text : ""
                weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
                dispatch_async(dispatch_get_main_queue(), {
                    if parentView != nil {
                        parentView!.composeView.setText(stringData!)
                    }
                })
            })
            mardownDocument.closeWithCompletionHandler(nil)
            self.currentOpenDocument = mardownDocument
            NSUserDefaults.standardUserDefaults().setObject(self.currentOpenDocument?.fileURL.lastPathComponent!, forKey: Constants.previouslyOpenDocument)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
    //MARK: saving
    
    func saveWithName(name: String, data: String) {
        var documentToBesaved: MarkdownDocument?
        for doc: MarkdownDocument in self.documents {
            if doc.fileURL.lastPathComponent == "\(name).md" || doc.fileURL.lastPathComponent == name {
                documentToBesaved = doc
            }
        }
        if documentToBesaved == nil {
            documentToBesaved = MarkdownDocument(fileURL: self.getDocURL(name))
            documentToBesaved?.text = data
            documentToBesaved!.saveToURL(self.getDocURL(name), forSaveOperation: .ForCreating, completionHandler: { (success) in
                if success {
                    print("successfuly created Document")
                } else {
                    print("failed to save document")
                }
            })
            self.documents.append(documentToBesaved!)
        } else {
            documentToBesaved?.text = data
            documentToBesaved!.saveToURL((documentToBesaved?.fileURL)!, forSaveOperation: .ForOverwriting, completionHandler: { (success) in
                if success {
                    print("successfuly overwrote document")
                } else {
                    print("failed to overwrite document")
                }
            })
        }
        self.currentOpenDocument = documentToBesaved
        NSUserDefaults.standardUserDefaults().setObject(self.currentOpenDocument?.fileURL.lastPathComponent!, forKey: Constants.previouslyOpenDocument)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: deleteing
    
    func deleteDocumentWithName(name: String) {
        var documentsCopy: [MarkdownDocument] = []
        weak var parentView: ConmposeViewController? = UIApplication.sharedApplication().keyWindow!.rootViewController as? ConmposeViewController
        if name == self.currentOpenDocument?.fileURL.lastPathComponent {
            self.currentOpenDocument = nil
            parentView?.composeView.setText("")
        }
        for doc: MarkdownDocument in self.documents {
            if name != doc.fileURL.lastPathComponent {
                documentsCopy.append(doc)
            } else {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(doc.fileURL)
                } catch {
                    print("failed to delete document")
                }
            }
        }
    }
}
