//
//  DeleteButton.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/16/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class DeleteButton: UIButton {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setImage(UIImage(named: "x2"), for: .normal)
        self.contentMode = .scaleAspectFill
        alpha = 0.6
        tag = 1001
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
