//
//  SecondsFromDate.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/1/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation
extension Date {
    func dateToSeconds() -> Int {
        let calendar = Calendar.current
        var totalSeconds = 0
        
        let hours = calendar.component(.hour, from: self)
        totalSeconds = hours * 3600
        let minutes = calendar.component(.minute, from: self)
        totalSeconds += minutes * 60
        let seconds = calendar.component(.second, from: self)
        totalSeconds += seconds
        return totalSeconds
    }
}

