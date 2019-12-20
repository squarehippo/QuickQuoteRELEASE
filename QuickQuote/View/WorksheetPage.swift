//
//  WorkOrderWorkSheet.swift
//  QuickQuote
//
//  Created by Brian Wilson on 12/14/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class WorksheetPage: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var irrigation: UILabel!
    @IBOutlet weak var waste: UILabel!
    @IBOutlet weak var water: UILabel!
    @IBOutlet weak var turf: UILabel!
    @IBOutlet weak var equipmentAccess: UILabel!
    @IBOutlet weak var equipmentNeeded: UILabel!
    @IBOutlet weak var sodKicker: UILabel!
    @IBOutlet weak var locator: UILabel!
    @IBOutlet weak var generalAccess: UILabel!
    @IBOutlet weak var handDig: UILabel!
    @IBOutlet weak var transitNeeded: UILabel!
    @IBOutlet weak var gateSize: UILabel!
    @IBOutlet weak var sodAmount: UILabel!
    
    @IBOutlet weak var flexGrates: UILabel!
    @IBOutlet weak var popUps: UILabel!
    @IBOutlet weak var CBs: UILabel!
    @IBOutlet weak var Ys: UILabel!
    @IBOutlet weak var Ts: UILabel!
    @IBOutlet weak var Cs: UILabel!
    
    @IBOutlet weak var pipe1Feet: UILabel!
    @IBOutlet weak var pipe1Diameter: UILabel!
    @IBOutlet weak var pipe2Feet: UILabel!
    @IBOutlet weak var pipe2Diameter: UILabel!
  
    @IBOutlet weak var workorderNumber: UILabel!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("WorksheetPage", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
}

