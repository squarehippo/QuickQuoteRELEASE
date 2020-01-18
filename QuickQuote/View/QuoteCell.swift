//
//  QuoteCell.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/28/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation
import UIKit
//@IBDesignable

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var quoteCellView: UIView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var quoteStatusView: UIView!
    @IBOutlet weak var quoteImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
    }
}
