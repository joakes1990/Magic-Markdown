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
    var useiCloud: Bool = false
    var iCloudRoot: URL?
    fileprivate var Query: NSMetadataQuery?
    
    override init() {
        super.init()

        let docNames: [String] = self.listAllDocuments()
        for name: String in docNames {
            let document: MarkdownDocument = MarkdownDocument(fileURL: self.getDocURL(name))
            self.documents.append(document)
       }
    }
    
     func checkforiCloud() {
        guard let iCloudRootDir = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.oklasoft.Magic-Markdown")
            else {
                print("icloud Not available")
                return
        }
            self.iCloudRoot = iCloudRootDir.appendingPathComponent("/Documents")
            if UserDefaults.standard.bool(forKey: Constants.askedForiCloud) {
                self.useiCloud = UserDefaults.standard.bool(forKey: Constants.useiCloud)
            } else {
                // Message to ask about iCloud set asked for icloud to true in observer
                let notification: Notification = Notification(name: Notification.Name(rawValue: Constants.askForiCloudnotification), object: nil)
                NotificationCenter.default.post(notification)
            }
    }
    
    class func appHasBeenOpen() -> Bool {
        let opened: Bool? = UserDefaults.standard.bool(forKey: Constants.previouslyRanDefault)
        if opened != nil && opened == true {
            return true
        } else {
            UserDefaults.standard.set(true, forKey: Constants.previouslyRanDefault)
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    class func defaultString() -> String {
        do {
            return try String(contentsOfFile: Bundle.main.path(forResource: "firstRun", ofType: "md")!)
        } catch {
            print("failed to read file from bundel")
            return ""
        }
        
    }
    
    class func previousDocumentAvailable() -> Bool {
        let previousDocumentName = UserDefaults.standard.string(forKey: Constants.previouslyOpenDocument)
        if previousDocumentName != nil && !DocumentManager.sharedInstance.docNameAvailable(previousDocumentName!) {
            return true
        } else {
            return false
        }
    }
    
    func docNameAvailable(_ name: String) -> Bool {
        var nameAvailable: Bool = true
        for doc: MarkdownDocument in self.documents {
            if doc.fileURL.lastPathComponent == name {
                nameAvailable = false
            }
        }
        return nameAvailable
    }
    
    func getDocURL(_ name: String) -> URL {
        if self.useiCloud {
            return name.characters.count > 3 && name.substring(from: name.characters.index(name.startIndex, offsetBy: name.characters.count - 3)) == ".md" ? self.iCloudRoot!.appendingPathComponent(name) : self.iCloudRoot!.appendingPathComponent("\(name).md")
        } else {
            return name.characters.count > 3 && name.substring(from: name.characters.index(name.startIndex, offsetBy: name.characters.count - 3)) == ".md" ? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name) : FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name).appendingPathExtension("md")
        }
    }
    
    //MARK: opening
    
    @discardableResult func listAllDocuments() -> [String] {
        var docsDirURL: URL
        if self.useiCloud {
            docsDirURL = self.iCloudRoot!
        } else {
            docsDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
            var files: [String] = []
            do {
                files = try FileManager.default.contentsOfDirectory(atPath: docsDirURL.path)
            } catch {
                print("No documents found")
            }
        
        self.documents = []
        for doc: String in files {
            self.documents.append(MarkdownDocument(fileURL: self.getDocURL(doc)))
        }
        let notification: Notification = Notification(name: Notification.Name(rawValue: Constants.documentsReady), object: nil)
        NotificationCenter.default.post(notification)
        return files
    }
    
    func openDocumentWithName(_ name: String) {
        var fileURL: URL
        if self.useiCloud {
            fileURL = iCloudRoot!.appendingPathComponent(name)
            
        } else {
            fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
        }
            let mardownDocument: MarkdownDocument = MarkdownDocument(fileURL: fileURL)
            mardownDocument.open(completionHandler: { (success) in
                if !success {
                    print("failed to open")
                    return
                }
                let stringData = mardownDocument.text != nil ? mardownDocument.text : ""
                weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
                DispatchQueue.main.async(execute: {
                    if parentView != nil {
                        parentView!.composeView.setText(stringData!)
                        parentView?.titleLabel.title = name
                    }
                })
            })
            mardownDocument.close(completionHandler: nil)
            self.currentOpenDocument = mardownDocument
            UserDefaults.standard.set(self.currentOpenDocument?.fileURL.lastPathComponent, forKey: Constants.previouslyOpenDocument)
            UserDefaults.standard.synchronize()
    }
    
    
    //MARK: saving
    
    func saveWithName(_ name: String, data: String) {
        var documentToBesaved: MarkdownDocument?
        weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
        for doc: MarkdownDocument in self.documents {
            if doc.fileURL.lastPathComponent == "\(name).md" || doc.fileURL.lastPathComponent == name {
                documentToBesaved = doc
            }
        }
        if documentToBesaved == nil {
            documentToBesaved = MarkdownDocument(fileURL: self.getDocURL(name))
            documentToBesaved?.text = data
            documentToBesaved!.save(to: self.getDocURL(name), for: .forCreating, completionHandler: { (success) in
                if success {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.saveSuccessful), object: nil))
                    parentView?.titleLabel.title = name
                } else {
                    print("failed to save document")
                }
            })
            self.documents.append(documentToBesaved!)
        } else {
            documentToBesaved?.text = data
            documentToBesaved!.save(to: (documentToBesaved?.fileURL)!, for: .forOverwriting, completionHandler: { (success) in
                if success {
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.saveSuccessful), object: nil))
                    parentView?.titleLabel.title = name
                } else {
                    print("failed to overwrite document")
                }
            })
        }
        self.currentOpenDocument = documentToBesaved
        UserDefaults.standard.set(self.currentOpenDocument?.fileURL.lastPathComponent, forKey: Constants.previouslyOpenDocument)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: deleteing
    
    func deleteDocumentWithName(_ name: String) {
        var documentsCopy: [MarkdownDocument] = []
        weak var parentView: ConmposeViewController? = UIApplication.shared.keyWindow!.rootViewController as? ConmposeViewController
        if name == self.currentOpenDocument?.fileURL.lastPathComponent {
            self.currentOpenDocument = nil
            parentView?.composeView.setText("")
            parentView?.titleLabel.title = "Untitled Document"
        }
        for doc: MarkdownDocument in self.documents {
            if name != doc.fileURL.lastPathComponent {
                documentsCopy.append(doc)
            } else {
                do {
                    try FileManager.default.removeItem(at: doc.fileURL)
                } catch {
                    print("failed to delete document")
                }
            }
        }
        self.documents = documentsCopy
    }
    
    //MARK: renameing
    
    func renameFileNamed(_ name: String, newName: String) {
        let newDestination = newName.characters.count > 3 && newName.substring(from: newName.characters.index(newName.startIndex, offsetBy: newName.characters.count - 3)) == ".md" ? newName : "\(newName).md"
        let newDocumentURL: URL = self.useiCloud ? (self.iCloudRoot?.appendingPathComponent(newDestination))! : FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(newDestination)
        for doc: MarkdownDocument in self.documents {
            if doc.fileURL.lastPathComponent == name {
                do {
                    try FileManager.default.moveItem(at: doc.fileURL, to: newDocumentURL)
                    self.documents = []
                    let docNames: [String] = self.listAllDocuments()
                    for name: String in docNames {
                        let document: MarkdownDocument = MarkdownDocument(fileURL: self.getDocURL(name))
                        self.documents.append(document)
                    }
                    self.currentOpenDocument = MarkdownDocument(fileURL: newDocumentURL)
                } catch {
                    print("failed to rename document")
                }
            }
        }        
    }
    

}
