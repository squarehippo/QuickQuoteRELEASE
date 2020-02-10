//
//  TaskView.swift
//  QuickQuote
//
//  Created by Brian Wilson on 1/27/20.
//  Copyright © 2020 Brian Wilson. All rights reserved.
//

import UIKit

class TaskView: UIView {
    
    var height = 1.0
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskCost: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    
    override public var intrinsicContentSize: CGSize {
      return CGSize(width: 1.0, height: height)
    }
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          setup()
      }
      
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          setup()
      }
      
      func setup() {
          Bundle.main.loadNibNamed("TaskView", owner: self, options: nil)
          addSubview(contentView)
          contentView.frame = self.bounds
      }
}
