//
//  ViewController.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Cocoa
import IOBluetooth
import WidgetKit

fileprivate enum MenuItemTypePosition: Int {
    case batteryView = 0
    case airpodsConnect = 2
    case credit = 5
    case about = 6
    case refreshDevices = 8
    case startupLaunch = 10
    case quitApp = 12
}

class StatusMenuController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var airpodsBatteryStatusView: BatteryAirpodsView!
    
    var batteryStatusMenuItem: NSMenuItem!
    var airpodsBatteryViewModel: AirPodsBatteryViewModel!
    
    private var timer: Timer?
    private var airpodsModeTimer: Timer?
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let tickingInterval: TimeInterval = 30
    
    private lazy var aboutView: AboutWindow = {
        return AboutWindow()
    }()
    
    private lazy var creditView: CreditWindow = {
        return CreditWindow()
    }()
    
    private lazy var settingsView: PreferenceSettingsWindow = {
        return PreferenceSettingsWindow()
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        airpodsBatteryViewModel = AirPodsBatteryViewModel()
        setupStatusMenu()
        setUpRecurrentChecks()
        
        NotificationCenter.default.addObserver(self, selector: #selector(detectChange), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoTimer), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateDeviceName), name: NSNotification.Name("update_device_name"), object: nil)
        
        self.updateBatteryValue()
    }
    
    fileprivate func setUpRecurrentChecks() {
        
        timer = Timer.scheduledTimer(timeInterval: tickingInterval,
                                     target: self,
                                     selector: #selector(updateBatteryValue),
                                     userInfo: nil,
                                     repeats: true)
        
        airpodsModeTimer = Timer.scheduledTimer(timeInterval: 3,
                                                target: self,
                                                selector: #selector(updateAirpodsMode),
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
        refreshStatusMenu()
    }
    
    @objc fileprivate func refreshStatusMenu() {
        statusMenu.item(at: MenuItemTypePosition.quitApp.rawValue)?.title = "quit_app".localized
        statusMenu.item(at: MenuItemTypePosition.refreshDevices.rawValue)?.title = "refresh_devices".localized
        statusMenu.item(at: MenuItemTypePosition.about.rawValue)?.title = "feedback".localized
        statusMenu.item(at: MenuItemTypePosition.credit.rawValue)?.title = "credits".localized
        statusMenu.item(at: MenuItemTypePosition.startupLaunch.rawValue)?.title = "settings".localized
        
        let statusMenuItem = statusMenu.item(at: MenuItemTypePosition.batteryView.rawValue)
        statusMenuItem?.view = airpodsBatteryStatusView
        
        statusItem.button?.title = ""
        statusItem.menu = statusMenu
        
        
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
            self.statusMenu.item(at: MenuItemTypePosition.airpodsConnect.rawValue)?.title = "No Airpods devices paired"
        }
    }
    
    @objc fileprivate func updateBatteryValue() {
        
        airpodsBatteryViewModel.updateBatteryInformation { [weak self] (success, connectionStatus, deviceType) in
            
            DispatchQueue.main.async {
                self?.airpodsBatteryStatusView.updateViewData(self?.airpodsBatteryViewModel)
                self?.statusItem.button?.title = self?.airpodsBatteryViewModel.fullStatusMessage ?? ""
                
                let pairedDevicesConnected = self?.airpodsBatteryViewModel.connectionStatus == .connected
                self?.updateStatusButtonImage(hide: pairedDevicesConnected)
                
                self?.updateDeviceName()
            }
        }
    }
    
    @objc fileprivate func updateAirpodsMode() {
        airpodsBatteryViewModel.updateAirpodsMode()
        statusItem.button?.title = airpodsBatteryViewModel.fullStatusMessage
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetIdentifiers.batteryMonitor.rawValue)
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
        NSApp.activate(ignoringOtherApps: true)
        aboutView.showWindow(nil)
    }
    
    @IBAction func creditAppClicked(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        creditView.showWindow(nil)
    }
    
    @IBAction func settingsAppClicked(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        settingsView.showWindow(nil)
    }
}
