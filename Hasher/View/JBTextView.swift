//
//  JBTextView.swift
//  Hasher
//
//  Created by Josip Bernat on 7/23/15.
//  Copyright (c) 2015 Josip Bernat. All rights reserved.
//

import Cocoa

class JBTextView: NSTextView {

    typealias TextdDidChangeBlock = (_ text: String?) -> Void
    
    var textChangedBlock: TextdDidChangeBlock?
    
    var placeholder: String = "" {
        
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    let placeholderFont = NSFont.systemFont(ofSize: 15.0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.drawsBackground = false
        self.font = NSFont.systemFont(ofSize: 15.0)
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer:container)
        
        self.drawsBackground = false
        self.font = NSFont.systemFont(ofSize: 15.0)
    }
    
    //MARK: - Override
    
    override func becomeFirstResponder() -> Bool {
        
        self.needsDisplay = true
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        
        self.needsDisplay = true
        return super.resignFirstResponder()
    }
    
    override func didChangeText() {
        
        self.textColor = isDarkTheme() ? NSColor.white : NSColor.black
        
        self.needsDisplay = true
        super.didChangeText()
        
        if let unwrappedBlock = textChangedBlock {
            unwrappedBlock(self.string)
        }
    }
    
    //MARK: - Drawing
    
    func isDarkTheme() -> Bool {
        if #available(OSX 10.14, *) {
            return NSAppearance.current.name == .darkAqua || NSAppearance.current.name == .vibrantDark
        } else {
            // Fallback on earlier versions
            return NSAppearance.current.name.rawValue.hasPrefix("NSAppearanceNameVibrantDark")
//            return convertFromNSAppearanceName(NSAppearance.current.name).hasPrefix("NSAppearanceNameVibrantDark")
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState()
        
        let hasText = self.string.utf16.count > 0 ? true : false
        if placeholder.utf16.count > 0 && hasText == false {
            
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: isDarkTheme() ? NSColor.white : NSColor.black,
                                                             .font: placeholderFont]
            
            (placeholder as NSString).draw(at: NSMakePoint(6.0, 0.0), withAttributes: attributes)
        }
        
        NSGraphicsContext.restoreGraphicsState()
    }
}

// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromNSAppearanceName(_ input: NSAppearance.Name) -> String {
//    return input.rawValue
//}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
