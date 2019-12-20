//
//  String+CurrencyFormat.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/18/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//
import UIKit

extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return self
    }
}


extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}


