//
//  DateToString.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/28/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation

extension Date {
    func dateToShortString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func dateToLongString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}
