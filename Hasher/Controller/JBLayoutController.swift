//
//  JBLayoutController.swift
//  Hasher
//
//  Created by Josip Bernat on 7/23/15.
//  Copyright (c) 2015 Josip Bernat. All rights reserved.
//

import Cocoa

class JBLayoutController: NSObject {

    static let sharedInstance = JBLayoutController()
    
    let statusItem: NSStatusItem
    let popover: NSPopover
    var popoverMonitor: AnyObject?
    
    //MARK: - Initialization
    override init() {
        popover = NSPopover()
        var controller = JBContentViewController(nibName: "JBContentViewController", bundle: nil)
        popover.contentViewController = controller
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(24)
        
        super.init()
        setupStatusButton()
    }
    
    //MARK: - Button
    
    func setupStatusButton() {
        
        if let statusButton = statusItem.button {
            
            statusButton.image = NSImage(named: "Status")
            statusButton.alternateImage = NSImage(named: "StatusHighlighted")
            
            // DummyControl interferes mouseDown events to keep statusButton highlighted while popover is open.
            let dummyControl = JBDummyControll()
            dummyControl.frame = statusButton.bounds
            statusButton.addSubview(dummyControl)
            statusButton.superview!.subviews = [statusButton, dummyControl]
            dummyControl.action = "onPress:"
            dummyControl.target = self
        }
    }
    
    func onPress(sender: AnyObject) {
        if popover.shown == false {
            openPopover()
        }
        else {
            closePopover()
        }
    }
    
    //MARK: - Popover Animations
    
    func openPopover() {
        
        if let statusButton = statusItem.button {
            
            statusButton.highlight(true)
            popover.showRelativeToRect(NSZeroRect, ofView: statusButton, preferredEdge: NSMinYEdge)
            popoverMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(.LeftMouseDownMask, handler: { (event: NSEvent!) -> Void in
                self.closePopover()
            })
        }
    }
    
    func closePopover() {
        
        popover.close()
        
        if let statusButton = statusItem.button {
            statusButton.highlight(false)
        }
        if let monitor : AnyObject = popoverMonitor {
            NSEvent.removeMonitor(monitor)
            popoverMonitor = nil
        }
    }
}
