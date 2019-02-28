//
//  JBDummyControll.swift
//  Hasher
//
//  Created by Josip Bernat on 7/23/15.
//  Copyright (c) 2015 Josip Bernat. All rights reserved.
//

import Cocoa

class JBDummyControll: NSControl {

    override func mouseDown(with theEvent: NSEvent) {
        superview!.mouseDown(with: theEvent)
        sendAction(action, to: target)
    }
}
