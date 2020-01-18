//
//  CoverSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/15/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class CoverSheet: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress1: UILabel!
    @IBOutlet weak var customerAddress2: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeEmail: UILabel!
    @IBOutlet weak var employeePhone: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("CoverSheet", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }

}
