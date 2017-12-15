//
//  MarkdownDocument.swift
//  Magic Markdown
//
//  Created by Justin Oakes on 6/4/16.
//  Copyright © 2016 Oklasoft LLC. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MarkdownDocument: UIDocument {

    var text: String?
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        
        if (contents as AnyObject).length > 0 {
            self.text = String(data: contents as! Data, encoding: String.Encoding.utf8)
        } else {
            self.text = ""
        }
    }
    
    override func contents(forType typeName: String) throws -> Any {
        if self.text == nil {
            self.text = ""
        }
        let docData: Data = self.text!.data(using: String.Encoding.utf8)!
        return docData
    }
    
}
