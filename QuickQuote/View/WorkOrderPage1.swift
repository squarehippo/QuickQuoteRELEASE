//
//  WorkOrderPage1.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/13/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class WorkOrderPage1: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var workOrderNumber: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    @IBOutlet weak var customerAddress2: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var workOrderNotes: UITextView!
    
    @IBOutlet weak var materialView: UIView!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("WorkOrderPage1", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
//        let containerView = UINib(nibName: String(describing: WorkOrderPage1.self), bundle: nil)
//        .instantiate(withOwner: nil, options: nil).first as! WorkOrderPage1
//        addSubview(containerView)
//        containerView.frame = self.bounds
    }
}

