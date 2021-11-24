//
//  NSScreen+Extension.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 19/11/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa

extension NSScreen {
    var hasTopNotchDesign: Bool {
        guard #available(macOS 12, *) else { return false }
        return safeAreaInsets.top != 0
    }
    
 
}
