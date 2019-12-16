//
//  AboutView.swift
//  DarkMode Switcher
//
//  Created by Mohamed Arradi on 6/11/18.
//  Copyright © 2018 Mohamed ARRADI. All rights reserved.
//

import Foundation
import Cocoa

class AboutWindow: NSWindowController {
    
    @IBOutlet weak var appIconImageView: NSImageView!
    @IBOutlet weak var appNameLabel: NSTextField!
    @IBOutlet weak var appBuildVersionLabel: NSTextField!
    @IBOutlet weak var feedbackButton: NSButton!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("AboutWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.titlebarAppearsTransparent =  true
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        appNameLabel.stringValue = "Airpods Battery Monitor"
       
        guard let releaseVersionNumber = Bundle.main.releaseVersionNumber, let buildNumber = Bundle.main.buildVersionNumber else {
            return
        }
        
        appBuildVersionLabel.stringValue = "Version ".appending(releaseVersionNumber).appending(String(format: ".%@", buildNumber))
    }
    
    @IBAction func sendFeedback(sender: NSButton) {
        
        guard let service = NSSharingService(named: NSSharingService.Name.composeEmail) else {
            return
        }
        service.recipients = ["hello@arradimohamed.fr"]
        service.subject = "Feedback"
        service.perform(withItems: ["Write your feedback here"])
    }
}
