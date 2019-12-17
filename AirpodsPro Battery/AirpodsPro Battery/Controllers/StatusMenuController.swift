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
    var airpodsBatteryViewModel: AirPodsBatteryViewModel!
    
    private var timer: Timer?
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let tickingInterval: TimeInterval = 200
    private lazy var aboutView: AboutWindow = {
        return AboutWindow()
    }()
    
    private lazy var creditView: CreditWindow = {
        return CreditWindow()
    }()
    
    override init() {
        super.init()
        let scriptHandler = ScriptsHandler(scriptsName: ["battery-airpods.sh", "mapmac.txt", "apple-devices-verification.sh"])
        
        airpodsBatteryViewModel = AirPodsBatteryViewModel(scriptHandler: scriptHandler)
        
        NotificationCenter.default.addObserver(self, selector: #selector(detectChange), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(undoTimer), name: NSNotification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
        
        updateBatteryValue()
        
        timer = Timer.scheduledTimer(timeInterval: tickingInterval,
                                         target: self,
                                         selector: #selector(updateBatteryValue),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStatusMenu()
        updateBatteryValue()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kIOBluetoothDeviceNotificationNameConnected), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kIOBluetoothDeviceNotificationNameDisconnected), object: nil)
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
        statusMenu.item(at: MenuItemTypePosition.refreshDevices.rawValue)?.title = "refresh_devices".localized
        statusMenu.item(at: MenuItemTypePosition.about.rawValue)?.title = "feedback".localized
        statusItem.menu = statusMenu
        statusItem.button?.title = ""
        
        statusMenuItem = statusMenu.item(at: MenuItemTypePosition.batteryView.rawValue)
        statusMenuItem.view = batteryStatusView
        
        statusMenu.item(at: MenuItemTypePosition.credit.rawValue)?.title = "credits".localized
    }
    
    @objc fileprivate func detectChange() {
        updateBatteryValue()
    }
    
    @objc fileprivate func undoTimer() {
        timer?.invalidate()
        updateBatteryValue()
    }
    @objc fileprivate func updateBatteryValue() {
        
        airpodsBatteryViewModel.updateBatteryInformation { [weak self] (success, connectionStatus) in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                
                strongSelf.batteryStatusView.updateViewData(airpodsBatteryViewModel: strongSelf.airpodsBatteryViewModel)
                
                strongSelf.statusItem.button?.title = strongSelf.airpodsBatteryViewModel.displayStatusMessage
                
                let connected = strongSelf.airpodsBatteryViewModel.connectionStatus == .connected
                strongSelf.updateStatusButtonImage(hide: connected)
                
                if !strongSelf.airpodsBatteryViewModel.deviceName.isEmpty {
                    let format = connected ? "disconnect_from_airpods".localized : "connect_to_airpods".localized
                    let deviceName = strongSelf.airpodsBatteryViewModel.deviceName
                    
                    strongSelf.statusMenu.item(at: MenuItemTypePosition.airpodsConnect.rawValue)?.title = String(format: format, deviceName)
                } else {
                    strongSelf.statusMenu.item(at: MenuItemTypePosition.airpodsConnect.rawValue)?.title = "No devices paired yet"
                }
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

//@available(OSX 10.12.1, *)
//extension StatusMenuController: NSTouchBarDelegate {
//    override func makeTouchBar() -> NSTouchBar? {
//        let touchBar = NSTouchBar()
//        touchBar.delegate = self
//        // touchBar.customizationIdentifier = .travelBar
//        //    touchBar.defaultItemIdentifiers = [.infoLabelItem]
//        //    touchBar.customizationAllowedItemIdentifiers = [.infoLabelItem]
//        return touchBar
//    }
//}
