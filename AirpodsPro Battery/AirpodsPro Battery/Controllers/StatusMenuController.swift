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
    case about = 6
    case refreshDevices = 8
    case quitApp = 10
}

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var batteryStatusView: BatteryView!
    
    var statusMenuItem: NSMenuItem!
    lazy var airpodsBatteryViewModel: AirPodsBatteryViewModel = AirPodsBatteryViewModel()
    
    private var timer: Timer?
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let tickingInterval: TimeInterval = 30
    
    private lazy var aboutView: AboutWindow = {
        return AboutWindow()
    }()
    
    private lazy var creditView: CreditWindow = {
        return CreditWindow()
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupStatusMenu()
        setUpRecurrentChecks()
               
        updateBatteryValue()
        NotificationCenter.default.addObserver(self, selector: #selector(detectChange), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(undoTimer), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(updateDeviceName), name: NSNotification.Name("update_device_name"), object: nil)
       
    
    }
    
    fileprivate func setUpRecurrentChecks() {
        
        timer = Timer.scheduledTimer(timeInterval: tickingInterval,
                                     target: self,
                                     selector: #selector(updateBatteryValue),
                                     userInfo: nil,
                                     repeats: true)
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
        
        guard statusMenu != nil else {
            return
        }
        
        updateStatusButtonImage()
        
        statusMenu.item(at: MenuItemTypePosition.quitApp.rawValue)?.title = "quit_app".localized
        statusMenu.item(at: MenuItemTypePosition.refreshDevices.rawValue)?.title = "refresh_devices".localized
        statusMenu.item(at: MenuItemTypePosition.about.rawValue)?.title = "feedback".localized
        statusMenu.item(at: MenuItemTypePosition.credit.rawValue)?.title = "credits".localized
        statusItem.button?.title = ""
        statusItem.menu = statusMenu
        
        statusMenuItem = statusMenu.item(at: MenuItemTypePosition.batteryView.rawValue)
        statusMenuItem.view = batteryStatusView
    }
    
    @objc fileprivate func detectChange() {
        setUpRecurrentChecks()
        updateBatteryValue()
    }
    
    @objc fileprivate func undoTimer() {
        updateBatteryValue()
    }
    
    @objc fileprivate func updateDeviceName() {
        
        let pairedDevicesConnected = self.airpodsBatteryViewModel.connectionStatus == .connected
        
        let deviceName = self.airpodsBatteryViewModel.deviceName
        
        if !deviceName.isEmpty {
            let format = pairedDevicesConnected ? "disconnect_from_airpods".localized : "connect_to_airpods".localized
            
            self.statusMenu.item(at: MenuItemTypePosition.airpodsConnect.rawValue)?.attributedTitle = NSAttributedString(string: String(format: format, deviceName))  
        } else {
            self.statusMenu.item(at: MenuItemTypePosition.airpodsConnect.rawValue)?.title = "No devices paired yet"
        }
    }
    
    @objc fileprivate func updateBatteryValue() {
        
        airpodsBatteryViewModel.updateBatteryInformation { [weak self] (success, connectionStatus) in
            
            DispatchQueue.main.async {
                
                self?.batteryStatusView.updateViewData(self?.airpodsBatteryViewModel)
                
                self?.statusItem.button?.title = self?.airpodsBatteryViewModel.displayStatusMessage ?? ""
                
                let pairedDevicesConnected = self?.airpodsBatteryViewModel.connectionStatus == .connected
                self?.updateStatusButtonImage(hide: pairedDevicesConnected)
                
                self?.updateDeviceName()
            }
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
    
    @IBAction func refreshDevices(_ sender: NSMenuItem) {
        updateBatteryValue()
    }
    
    @IBAction func aboutAppClicked(_ sender: NSMenuItem) {
        aboutView.showWindow(nil)
    }
    
    @IBAction func creditAppClicked(_ sender: NSMenuItem) {
        creditView.showWindow(nil)
    }
}
