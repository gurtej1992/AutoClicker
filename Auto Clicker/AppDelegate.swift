//
//  AppDelegate.swift
//  Auto Clicker
//
//  Created by Tej on 21/12/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        // Insert code here to tear down your application
    }
    
    @IBAction func handleSave(_ sender: Any) {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        let i = savePanel.runModal()
        if i == NSApplication.ModalResponse.OK {
            NotificationCenter.default.post(name: Helper.saveFileNotification, object: savePanel.url!)
            print("The directory selected is " + savePanel.url!.absoluteString)
        }
    }
    @IBAction func handleOpen(_ sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowedFileTypes = ["plist"]
        let i = openPanel.runModal()
        if i == NSApplication.ModalResponse.OK {
            NotificationCenter.default.post(name: Helper.openFileNotification, object: openPanel.url!)
            print("The directory selected is " + openPanel.url!.absoluteString)
        }
    }
}

