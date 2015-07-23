//
//  JBContentViewController.swift
//  Hasher
//
//  Created by Josip Bernat on 7/23/15.
//  Copyright (c) 2015 Josip Bernat. All rights reserved.
//

import Cocoa
import CryptoSwift

class JBContentViewController: NSViewController {
    
    @IBOutlet var textView: JBTextView!
    
    @IBOutlet weak var md5Label: NSTextField!
    @IBOutlet weak var resultLabel: NSTextField!

    //MARK: - Memory Management
    
    deinit {
        textView.textChangedBlock = nil
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.placeholder = "Enter text you want to hash"
        textView.textChangedBlock = { [weak self] (text) -> Void in
            
            if let strongThis = self {
                strongThis.md5Hash(text)
            }
        }
        
        md5Label.stringValue = NSLocalizedString("MD5 hash", comment: "")
        resultLabel.stringValue = ""
    }
    
    //MARK: - Hashing
    
    func md5Hash(text: String?) {
    
        if let unwrappedText = text {
            
            if count(unwrappedText.utf16) == 0 {
                resultLabel.stringValue = ""
            }
            else {
                
                if let data = (unwrappedText as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
                
                    if let hash = data.md5() {
                        resultLabel.stringValue = hash.hexString
                    }
                    else {
                        resultLabel.stringValue = ""
                    }
                }
                else {
                    resultLabel.stringValue = ""
                }
            }
        }
        else {
            resultLabel.stringValue = ""
        }
    }
}
