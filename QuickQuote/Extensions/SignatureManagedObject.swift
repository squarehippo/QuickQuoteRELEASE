//
//  SignatureManagedObject.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/22/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation

extension SignatureManagedObject {
    func sign() {
        let now = Date()
        if dateCreated == .none {
            dateCreated = now
            dateModified = now
        }
        dateModified = now
    }
}
