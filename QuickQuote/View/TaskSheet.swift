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
    
    @IBOutlet weak var task1Title: UILabel!
    @IBOutlet weak var task1Description: UITextView!
    @IBOutlet weak var task2Title: UILabel!
    @IBOutlet weak var task2Description: UITextView!
    @IBOutlet weak var task3Title: UILabel!
    @IBOutlet weak var task3Description: UITextView!
    @IBOutlet weak var task4Title: UILabel!
    @IBOutlet weak var task4Description: UITextView!
    
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    
    @IBOutlet weak var stackView2Height: NSLayoutConstraint!
    @IBOutlet weak var stackView3Height: NSLayoutConstraint!
    @IBOutlet weak var stackView4Height: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           setup()
       }
       
       func setup() {
           Bundle.main.loadNibNamed("TaskSheet", owner: self, options: nil)
           addSubview(contentView)
           contentView.frame = self.bounds
       }
}
