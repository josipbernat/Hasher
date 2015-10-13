//
//  AppDelegate.swift
//  Hasher
//
//  Created by Josip Bernat on 7/23/15.
//  Copyright (c) 2015 Josip Bernat. All rights reserved.
//

import Cocoa

@NSApplicationMain
class JBAppDelegate: NSObject, NSApplicationDelegate {
    
    var layoutController = JBLayoutController.sharedInstance
    var databaseController = JBDatabaseController.sharedInstance
    
    //MARK: - NSApplicationDelegate
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

