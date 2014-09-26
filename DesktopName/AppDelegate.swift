//
//  AppDelegate.swift
//  DesktopName
//
//  Created by Stephen Sykes on 25/09/14.
//  Copyright (c) 2014 Switchstep. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem : NSStatusItem!
    var timer : NSTimer!

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        let statusBar = NSStatusBar.systemStatusBar()
        statusItem = statusBar.statusItemWithLength(49)
        statusItem.menu = menu()
        
        let current = tsapi_currentSpaceNumberOnDisplay(0);
        setTitle(nameForSpace(current))
        
        setSpaceChangeCallback(spaceChanged)
        
        timer = NSTimer(timeInterval: 2, target: self, selector: "watchdog:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }

    func nameForSpace(space: UInt32) -> String {
        let name = tsapi_spaceNameForSpaceNumberOnDisplay(space, 0)
        let str = String.fromCString(UnsafePointer<CChar>(name))

        tsapi_freeString(UnsafeMutablePointer<Int8>(name))
        
        if let s = str {
            return s
        } else {
            return ""
        }
    }
    
    func spaceChanged(from: UInt32, to: UInt32, display: UInt32) {
//        println("\(from) \(to)")
        setTitle(nameForSpace(to))
    }
    
    func setTitle(name : String) {
        let font = NSFont(name: "Helvetica-Light", size: 9)
        let attrs = [
            NSFontAttributeName : font
        ]
        let str = NSAttributedString(string: name, attributes: attrs)
        statusItem.attributedTitle = str
    }
    
    func watchdog(timer : NSTimer) {
        let space = tsapi_currentSpaceNumberOnDisplay(0)
        setTitle(nameForSpace(space))
    }
    
    func menu() -> NSMenu {
        let menu = NSMenu(title: "DesktopName")
        menu.addItem(quitMenuItem())
        return menu
    }
    
    func quitMenuItem() -> NSMenuItem {
        let mi = NSMenuItem()
        mi.title = NSLocalizedString("Quit", comment: "Quit menu")
        mi.action = "quit:"
        mi.target = self
        return mi;
    }
    
    func quit(sender : AnyObject?) {
        NSApplication.sharedApplication().terminate(self)
    }

}

