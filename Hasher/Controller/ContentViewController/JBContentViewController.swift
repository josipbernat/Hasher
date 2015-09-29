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
    
    @IBOutlet weak var resultLabel: NSTextField!
    @IBOutlet weak var outputTextField: NSTextField!
    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var disclosureButton: NSButton!
    
    enum kHashType : String {
    
        case MD5 = "MD5",
        SHA1 = "SHA1",
        SHA224 = "SHA224",
        SHA256 = "SHA256",
        SHA384 = "SHA384",
        SHA512 = "SHA512"
        
        static let allValues = [MD5, SHA1, SHA224, SHA256, SHA384, SHA512]
    }
    
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
                
                if let unwrappedText = text {
                    strongThis.commitHash(unwrappedText)
                }
                else {
                    strongThis.textView.string = ""
                }
            }
        }
        
        comboBox.removeAllItems()
        for value in kHashType.allValues {
            comboBox.addItemWithObjectValue(value.rawValue)
        }
        comboBox.selectItemAtIndex(0)
        
        toogleResultLabelText()
        outputTextField.stringValue = ""
        
        disclosureButton.state = 1
    }
    
    //MARK: - ComboBox
    
    @IBAction func comboBoxSelected(sender: AnyObject) {
        
        selectedHash = kHashType.allValues[comboBox.indexOfSelectedItem]
        
        toogleResultLabelText()
        if let text = textView.string {
            commitHash(text)
        }
        else {
            commitHash("")
        }
    }
    
    func toogleResultLabelText() {
        resultLabel.stringValue = String(format: "%@ %@", selectedHash.rawValue, NSLocalizedString("result", comment: ""))
    }
    
    //MARK: - Button Selectors
    
    @IBAction func onDisclosure(sender: AnyObject) {
    
        let menu = NSMenu(title: "")
        menu.insertItemWithTitle("About", action: "onAbout:", keyEquivalent: "", atIndex: 0)
        menu.insertItemWithTitle("Quit", action: "onQuit:", keyEquivalent: "", atIndex: 1)
        
        if let event = NSApp.currentEvent {
            NSMenu.popUpContextMenu(menu, withEvent: event, forView: sender as! NSView)
        }
    }
    
    func onAbout(sender: AnyObject) {
        NSApplication.sharedApplication().orderFrontStandardAboutPanel(self)
    }
    
    func onQuit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    //MARK: - Hashing
    
    func commitHash(text: String) {
    
        if text.utf16.count == 0 {
            outputTextField.stringValue = ""
            return
        }
   
        outputTextField.stringValue = hashedString(text)
        print(outputTextField.stringValue)
    }
    
    var selectedHash = kHashType.MD5
    func hashedString(string: String) -> String {
    
        if let data = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding) {
        
            var hashData: NSData?
            
            switch selectedHash {
                
            case .MD5:
                hashData = data.md5()
                
            case .SHA1:
                hashData = data.sha1()
                
            case .SHA224:
                hashData = data.sha224()
                
            case .SHA256:
                hashData = data.sha256()
                
            case .SHA384:
                hashData = data.sha384()
                
            case .SHA512:
                hashData = data.sha512()
            }
            
            if let unwrappedHash = hashData {
                return unwrappedHash.toHexString()
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
}
