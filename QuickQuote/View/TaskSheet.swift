//
//  QuoteSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/15/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class TaskSheet: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        let nib = UINib(nibName: "TaskSheet", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
