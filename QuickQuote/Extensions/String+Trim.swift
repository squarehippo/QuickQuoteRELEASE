//
//  String+Trim.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/23/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
