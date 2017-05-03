//
//  AppDelegate.swift
//  DesktopName
//
//  Created by Stephen Sykes on 25/09/14.
//  Copyright (c) 2014 Switchstep. All rights reserved.
//

import Cocoa

@NSApplicationMain class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem : NSStatusItem!
    var timer : Timer!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBar = NSStatusBar.system()
        statusItem = statusBar.statusItem(withLength: 49)
        statusItem.menu = menu()
        
        let current = tsapi_currentSpaceNumberOnDisplay(0);
        setTitle(nameForSpace(current))
        
        setSpaceChangeCallback(spaceChanged)
        
        timer = Timer(timeInterval: 2, target: self, selector: #selector(AppDelegate.watchdog(_:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }

    func nameForSpace(_ space: UInt32) -> String {
        let name = tsapi_spaceNameForSpaceNumberOnDisplay(space, 0)

        guard name != nil
            else {return ""}

        let str = String(cString: UnsafePointer<CChar>(name!))

        tsapi_freeString(UnsafeMutablePointer<Int8>(mutating: name))

        return str
    }
    
    func spaceChanged(_ from: UInt32, to: UInt32, display: UInt32) {
//        println("\(from) \(to)")
        setTitle(nameForSpace(to))
    }
    
    func setTitle(_ name : String) {
        let font = NSFont(name: "Helvetica-Light", size: 9)
        let attrs : [String : Any] = [
            NSFontAttributeName : font as Any,
            NSBaselineOffsetAttributeName : -1.5
        ]
        let str = NSAttributedString(string: name, attributes: attrs)
        statusItem.attributedTitle = str
    }
    
    func watchdog(_ timer : Timer) {
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
        mi.action = #selector(AppDelegate.quit(_:))
        mi.target = self
        return mi;
    }
    
    func quit(_ sender : AnyObject?) {
        NSApplication.shared().terminate(self)
    }

}

