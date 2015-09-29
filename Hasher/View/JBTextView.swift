//
//  JBTextView.swift
//  Hasher
//
//  Created by Josip Bernat on 7/23/15.
//  Copyright (c) 2015 Josip Bernat. All rights reserved.
//

import Cocoa

class JBTextView: NSTextView {

    typealias TextdDidChangeBlock = (text: String?) -> Void
    
    var textChangedBlock: TextdDidChangeBlock?
    
    var placeholder: String = "" {
        
        didSet {
            self.setNeedsDisplayInRect(self.bounds)
        }
    }
    
    let placeholderFont = NSFont.systemFontOfSize(15.0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.drawsBackground = false
        self.font = NSFont.systemFontOfSize(15.0)
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer:container)
        
        self.drawsBackground = false
        self.font = NSFont.systemFontOfSize(15.0)
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
        
        self.textColor = isDarkTheme() ? NSColor.whiteColor() : NSColor.blackColor()
        
        self.needsDisplay = true
        super.didChangeText()
        
        if let unwrappedBlock = textChangedBlock {
            unwrappedBlock(text: self.string)
        }
    }
    
    //MARK: - Drawing
    
    func isDarkTheme() -> Bool {
        return NSAppearance.currentAppearance().name.hasPrefix("NSAppearanceNameVibrantDark")
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState()
        
        var hasText = false
        if let value = self.string {
            hasText = value.utf16.count > 0 ? true : false
        }
        
        if placeholder.utf16.count > 0 && hasText == false {
            
            let attributes = [NSForegroundColorAttributeName: isDarkTheme() ? NSColor.whiteColor() : NSColor.blackColor(),
                NSFontAttributeName: placeholderFont]
            
            (placeholder as NSString).drawAtPoint(NSMakePoint(6.0, 0.0), withAttributes: attributes)
        }
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
