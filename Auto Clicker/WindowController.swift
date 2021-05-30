//
//  WindowController.swift
//  Auto Clicker
//
//  Created by Tej on 25/12/20.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func saveDocument(_ sender: Any?) {
    // code to execute for save functionality
    // following line prints in debug to show function is executing.
    // delete print line below when testing is completed.
    print("save")
    }

    @IBAction func openDocument(_ sender: Any?) {
    // code to execute for open functionality here
    // following line prints in debug to show function is executing.
    // delete print line below when testing is completed.
     print("open")
    }
    
}
