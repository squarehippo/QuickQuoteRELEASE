//
//  CityStateZipToString.swift
//  QuickQuote
//
//  Created by Brian Wilson on 1/18/20.
//  Copyright © 2020 Brian Wilson. All rights reserved.
//

import Foundation

extension Customer
{
    func cityStateZipToString() -> String {
        if let city = self.city,
        let state = self.state,
        let zip = self.zip {
            return "\(city), \(state) \(zip)"
        }
        return ""
    }
}

