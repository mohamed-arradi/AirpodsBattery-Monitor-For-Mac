//
//  AlertUtil.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 14/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa

struct AlertUtil {
    
    @discardableResult
       func dialogOKCancel(question: String, text: String) -> Bool {
           let alert = NSAlert()
           alert.messageText = question
           alert.informativeText = text
           alert.alertStyle = .warning
           alert.addButton(withTitle: "OK".localized)
           return alert.runModal() == .alertFirstButtonReturn
       }
}
