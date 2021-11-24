//
//  System+Extension.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 24/11/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

extension OperatingSystemVersion {
    func getFullVersion(separator: String = ".") -> String {
        return "\(majorVersion)\(separator)\(minorVersion)\(separator)\(patchVersion)"
    }
}

var isMontereyOS: Bool {
    let os = ProcessInfo().operatingSystemVersion
    guard #available(macOS 12, *),
          os.majorVersion >= 12 else {
        return false
    }
    return true
}
