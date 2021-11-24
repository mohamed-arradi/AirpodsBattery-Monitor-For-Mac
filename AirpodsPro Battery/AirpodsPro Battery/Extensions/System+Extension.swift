//
//  System+Extension.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 24/11/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

var isMontereyOS: Bool {
    guard #available(macOS 12, *) else {
        return false
    }
    return true
}
