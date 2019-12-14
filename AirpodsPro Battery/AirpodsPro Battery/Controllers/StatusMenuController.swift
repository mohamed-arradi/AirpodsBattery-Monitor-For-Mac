//
//  ViewController.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Cocoa
import IOBluetooth

fileprivate enum MenuItemTypePosition: Int {
    case batteryView = 0
    case airpodsConnect = 2
    case credit = 5
    case about = 7
    case quitApp = 8
}

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var batteryStatusView: BatteryView!
    
    var statusMenuItem: NSMenuItem!
    var airpodsBatteryViewModel: BatteryViewModel!
    
    private var timer: Timer!
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let tickingInterval: TimeInterval = 60
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBatteryValue), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBatteryValue), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
    }
    
    deinit {
        timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: Notification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
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
        statusMenu.item(at: MenuItemTypePosition.quitApp.rawValue)?.title = "quit_app".localized
        statusMenu.item(at: MenuItemTypePosition.about.rawValue)?.title = "about".localized
        statusItem.menu = statusMenu
        statusItem.button?.title = ""
        
        statusMenuItem = statusMenu.item(at: MenuItemTypePosition.batteryView.rawValue)
        statusMenuItem.view = batteryStatusView
        
        statusMenu.item(at: MenuItemTypePosition.credit.rawValue)?.title = "credits".localized
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
            
            strongSelf.statusMenu.item(at: MenuItemTypePosition.airpodsConnect.rawValue)?.title = String(format: format, deviceName)
        }
    }
    
    // MARK: IBAction
    
    @IBAction func linkToAirpods(_ sender: NSMenuItem) {
        airpodsBatteryViewModel.toogleCurrentBluetoothDevice()
        updateBatteryValue()
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func aboutAppClicked(_ sender: NSMenuItem) {
        aboutView.showWindow(nil)
    }
    
    @IBAction func creditAppClicked(_ sender: NSMenuItem) {
        creditView.showWindow(nil)
    }
}

