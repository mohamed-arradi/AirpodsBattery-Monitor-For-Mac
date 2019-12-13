//
//  ViewController.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Cocoa
import IOBluetooth

fileprivate enum MenuItemType: Int {
    case batteryView = 0
    case airpodsConnect = 2
    case credit = 5
    case about = 7
    case quitApp = 8
}

class StatusMenuController: NSObject, NSAlertDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var batteryStatusView: BatteryView!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var statusMenuItem: NSMenuItem!
    
    private var timer: Timer!
    private let tickingInterval: TimeInterval = 3
    var airpodsBatteryViewModel: BatteryViewModel!
    
    private lazy var aboutView: AboutWindow = {
        return AboutWindow()
    }()
    
    private lazy var creditView: CreditWindow = {
        return CreditWindow()
    }()
    
    override func awakeFromNib() {
        
        setupStatusMenu()
        
        let scriptHandler = ScriptsHandler(scriptsName: ["battery-airpods.sh", "mapmac.txt"])
        
        airpodsBatteryViewModel = BatteryViewModel(scriptHandler: scriptHandler)
        
        updateBatteryValue()
        
        timer = Timer.scheduledTimer(timeInterval: tickingInterval, target: self, selector: #selector(updateBatteryValue), userInfo: nil, repeats: true)
    }
    
    deinit {
        timer.invalidate()
    }
    
    fileprivate func updateStatusButtonImage(hide: Bool = false) {
        
        if !hide {
            let icon = NSImage(imageLiteralResourceName: "StatusIconDisconnected")
            icon.isTemplate = true
            statusItem.button?.image = icon
        } else {
            let icon = NSImage(imageLiteralResourceName: "StatusIcon")
            icon.isTemplate = true
            statusItem.button?.image = icon
        }
        statusItem.button?.imagePosition = NSControl.ImagePosition.imageRight
    }
    
    fileprivate func setupStatusMenu() {
        
        statusItem.menu = statusMenu
        updateStatusButtonImage()
        statusMenu.item(at: MenuItemType.quitApp.rawValue)?.title = "quit_app".localized
        statusMenu.item(at: MenuItemType.about.rawValue)?.title = "about".localized
        statusItem.menu = statusMenu
        statusItem.button?.title = ""
        
        statusMenuItem = statusMenu.item(at: MenuItemType.batteryView.rawValue)
        statusMenuItem.view = batteryStatusView
        
        statusMenu.item(at: MenuItemType.credit.rawValue)?.title = "credits".localized
    }
    
    @objc fileprivate func updateBatteryValue() {
        
        airpodsBatteryViewModel.updateBatteryInformation { [weak self] (success, connectionStatus) in
            
            guard let strongSelf = self else { return }
            strongSelf.batteryStatusView.updateViewData(airpodsBatteryViewModel: strongSelf.airpodsBatteryViewModel)
            
            strongSelf.statusItem.button?.title = strongSelf.airpodsBatteryViewModel.displayStatusMessage
            
            let connected = strongSelf.airpodsBatteryViewModel.connectionStatus == .connected
            strongSelf.updateStatusButtonImage(hide: connected)
            
            let format = connected ? "disconnect_from_airpods".localized : "connect_to_airpods".localized
            let deviceName = strongSelf.airpodsBatteryViewModel.deviceName
            
            strongSelf.statusMenu.item(at: MenuItemType.airpodsConnect.rawValue)?.title = String(format: format, deviceName)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func linkToAirpods(_ sender: NSMenuItem) {
        
        let airpodsName = airpodsBatteryViewModel.deviceName
        
        guard !airpodsName.isEmpty,
            let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice],
            let airpodsDevice = devices.filter({ $0.name == airpodsName }).first else {
            return
        }
        
        if airpodsDevice.isConnected() {
            airpodsDevice.closeConnection()
        } else {
            airpodsDevice.openConnection()
        }
        
        updateBatteryValue()
    }
    
    @IBAction func aboutAppClicked(_ sender: NSMenuItem) {
        aboutView.showWindow(nil)
    }
    
    @IBAction func creditAppClicked(_ sender: NSMenuItem) {
        creditView.showWindow(nil)
    }
    
    @discardableResult
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
}

