//
//  String+Extensions.swift
//  ClaweeUI
//
//  Created by Danyl Timofeyev on 12.03.2021.
//

import Foundation

extension String {
    
    static func timeStringForExpirationTime(using interval: TimeInterval, isShortFormat: Bool = false) -> String {
        let days = Int(interval) / 86400
        let hours = Int(interval) / 3600 % 24
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        
        if days >= 1 {
            return String(format: isShortFormat ? "%02i:%02i" : "%02id:%02ih", days, hours)
        } else if hours >= 1 {
            return String(format: isShortFormat ? "%02i:%02i" : "%02ih:%02im", hours, minutes)
        }
        
        return String(format: isShortFormat ? "%02i:%02i" : "%02im:%02is", minutes, seconds)
    }
    
}

