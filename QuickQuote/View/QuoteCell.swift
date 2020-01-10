//
//  QuoteCell.swift
//  QuickQuote
//
//  Created by Brian Wilson on 10/28/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var quoteCellView: UIView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var quoteStatusView: UIView!
    @IBOutlet weak var quoteImageView: UIImageView!
    
        @IBInspectable var cornerRadius: CGFloat {
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = true
            }
            get {
                return layer.cornerRadius
            }
        }
    
        @IBInspectable var borderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = borderWidth
            }
        }
    
        @IBInspectable var borderColor: UIColor? {
            set {
                guard let uiColor = newValue else { return }
                layer.borderColor = uiColor.cgColor
            }
            get {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
}
