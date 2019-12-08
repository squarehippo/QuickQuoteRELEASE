//
//  PhotoView.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/26/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

class PhotoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoCaption: UITextView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        
    }

}
