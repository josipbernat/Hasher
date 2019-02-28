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
            comboBox.addItem(withObjectValue: value.rawValue)
        }
        comboBox.selectItem(at: 0)
        
        toogleResultLabelText()
        outputTextField.stringValue = ""
        
        disclosureButton.state = convertToNSControlStateValue(1)
    }
    
    //MARK: - ComboBox
    
    @IBAction func comboBoxSelected(_ sender: AnyObject) {
        
        selectedHash = kHashType.allValues[comboBox.indexOfSelectedItem]
        
        toogleResultLabelText()

        if textView.string.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            commitHash(textView.string)
        }
        else {
            commitHash("")
        }
    }
    
    func toogleResultLabelText() {
        resultLabel.stringValue = String(format: "%@ %@", selectedHash.rawValue, NSLocalizedString("result", comment: ""))
    }
    
    //MARK: - Button Selectors
    
    @IBAction func onDisclosure(_ sender: AnyObject) {
    
        let menu = NSMenu(title: "")
        menu.insertItem(withTitle: "About", action: #selector(JBContentViewController.onAbout(_:)), keyEquivalent: "", at: 0)
        menu.insertItem(withTitle: "Quit", action: #selector(JBContentViewController.onQuit(_:)), keyEquivalent: "", at: 1)
        
        if let event = NSApp.currentEvent {
            NSMenu.popUpContextMenu(menu, with: event, for: sender as! NSView)
        }
    }
    
    @objc func onAbout(_ sender: AnyObject) {
        NSApplication.shared.orderFrontStandardAboutPanel(self)
    }
    
    @objc func onQuit(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
    
    //MARK: - Hashing
    
    func commitHash(_ text: String) {
    
        if text.utf16.count == 0 {
            outputTextField.stringValue = ""
            return
        }
   
        outputTextField.stringValue = hashedString(text)
    }
    
    var selectedHash = kHashType.MD5
    func hashedString(_ string: String) -> String {
    
        if let data = (string as NSString).data(using: String.Encoding.utf8.rawValue) {
        
            var hashData: Data?
            
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSControlStateValue(_ input: Int) -> NSControl.StateValue {
	return NSControl.StateValue(rawValue: input)
}
