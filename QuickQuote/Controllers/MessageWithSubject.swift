//
//  MessageWithSubject.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/20/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class MessageWithSubject: NSObject, UIActivityItemSource {

    let subject:String
    let message:String

    init(subject: String, message: String) {
        self.subject = subject
        self.message = message

        super.init()
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return message
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return message
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return subject
    }
}
