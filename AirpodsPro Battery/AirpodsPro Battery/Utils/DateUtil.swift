//
//  DateUtil.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/07/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

struct DateUtil {
    
    private let dateFormater: DateFormatter
    
    init(datef: DateFormatter = DateFormatter()) {
        self.dateFormater = datef
    }
    
    func toDefaultStringFormat(date: Date, _ format: String? = "YY, MMM d, HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
