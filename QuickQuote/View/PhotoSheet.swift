//
//  PhotoSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/16/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class PhotoSheet: UIView {
    
    var currentQuote: Quote?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var quoteNumber: UILabel!
    @IBOutlet weak var photoStack1: UIStackView!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var caption1: UITextView!
    @IBOutlet weak var photoStack2: UIStackView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var caption2: UITextView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("PhotoSheet", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
    }
}
