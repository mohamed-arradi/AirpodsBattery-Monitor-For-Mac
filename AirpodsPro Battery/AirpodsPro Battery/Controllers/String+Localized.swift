//
//  String+Localized.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension String {
    
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch {
            return []
        }
    }
    
    func matches(for regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                if let range = Range($0.range, in: self) {
                    return String(self[range])
                }
                return ""
            }
        } catch let error {
            Logger.da("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func listeningMode() -> String {
        if self == NCListeningMode.normal.rawValue {
            return "Normal"
        }
        if self == NCListeningMode.anc.rawValue {
            return "Noise Cancellation"
        }
        if self == NCListeningMode.transparency.rawValue {
            return "Transparency"
        }
        return self
    }
}
