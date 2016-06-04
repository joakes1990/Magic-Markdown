//
//  MarkdownDocument.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/4/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit

class MarkdownDocument: UIDocument {

    var text: String?
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        
        if contents.length > 0 {
            self.text = String(data: contents as! NSData, encoding: NSUTF8StringEncoding)
        } else {
            self.text = ""
        }
    }
    
    override func contentsForType(typeName: String) throws -> AnyObject {
        if self.text == nil {
            self.text = ""
        }
        let docData: NSData = self.text!.dataUsingEncoding(NSUTF8StringEncoding)!
        return docData
    }
    
}
