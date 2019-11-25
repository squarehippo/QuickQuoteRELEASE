//
//  PhotoSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/16/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class PhotoSheet: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    @IBOutlet weak var photo4: UIImageView!
    @IBOutlet weak var photo5: UIImageView!
    @IBOutlet weak var caption1: UITextView!
    @IBOutlet weak var caption2: UITextView!
    @IBOutlet weak var caption3: UITextView!
    @IBOutlet weak var caption4: UITextView!
    @IBOutlet weak var caption5: UITextView!
    
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    
    
    
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
        addSubview(contentView)
        contentView.frame = self.bounds
    }
}
