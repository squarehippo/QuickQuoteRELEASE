//
//  Notification+Names.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/30/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let onChangeCustomer = Notification.Name("onChangeCustomer")
    static let onCreateNewQuote = Notification.Name("onCreateNewQuote")
    static let onDismissCustomerEdit = Notification.Name("onDismissCustomerEdit")
    static let onDismissNewCustomer = Notification.Name("onDismissNewCustomer")
    static let onDismissNewTask = Notification.Name("onDismissNewTask")
    static let onDismissImageModal = Notification.Name("onDismissImageModal")
    static let onDismissEmployee = Notification.Name("onDismissEmployee")
    static let onDismissLogin = Notification.Name("onDismissLogin")
    static let onDismissNewEmployee = Notification.Name("onDismissNewEmployee")
    static let onFirstRowHighlighted = Notification.Name("onFirstRowHighlighted")
    static let onCityAvailable = Notification.Name("onCityAvailable")
}
