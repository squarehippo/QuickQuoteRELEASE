//
//  DateToString.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/28/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df.string(from: self)
    }
}
