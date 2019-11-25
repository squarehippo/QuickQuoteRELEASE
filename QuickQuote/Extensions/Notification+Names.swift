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
    static let onDismissCustomerEdit = Notification.Name("onDismissCustomerEdit")
    static let onDismissNewTask = Notification.Name("onDismissNewTask")
    static let onDismissImageModal = Notification.Name("onDismissImageModal")
    static let onCityAvailable = Notification.Name("onCityAvailable")
}
