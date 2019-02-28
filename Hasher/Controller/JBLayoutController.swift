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
        let controller = JBContentViewController(nibName: "JBContentViewController", bundle: nil)
        popover.contentViewController = controller
        statusItem = NSStatusBar.system.statusItem(withLength: 24)
        
        super.init()
        setupStatusButton()
    }
    
    //MARK: - Button
    
    func setupStatusButton() {
        
        if let statusButton = statusItem.button {
            
            statusButton.image = NSImage(named: "Status")
            statusButton.image?.isTemplate = true
            
            // DummyControl interferes mouseDown events to keep statusButton highlighted while popover is open.
            let dummyControl = JBDummyControll()
            dummyControl.frame = statusButton.bounds
            statusButton.addSubview(dummyControl)
            statusButton.superview!.subviews = [statusButton, dummyControl]
            dummyControl.action = #selector(JBLayoutController.onPress(_:))
            dummyControl.target = self
        }
    }
    
    @objc func onPress(_ sender: AnyObject) {
        if popover.isShown == false {
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
            popover.show(relativeTo: NSZeroRect, of: statusButton, preferredEdge: NSRectEdge.minY)
            popoverMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown, handler: { (event: NSEvent) -> Void in
                self.closePopover()
            }) as AnyObject
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
