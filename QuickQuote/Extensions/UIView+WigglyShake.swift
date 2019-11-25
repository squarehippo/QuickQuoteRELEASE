//
//  UIView+WigglyShake.swift
//  QuickQuote
//
//  Created by Brian Wilson on 11/16/19.
//  Copyright © 2019 Brian Wilson. All rights reserved.
//

import UIKit

extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }
    
    func shakeLogin() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
    
    func wiggle() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(rotationAngle: 0.02)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .repeat, .autoreverse, .curveEaseInOut], animations: {
                self.transform = CGAffineTransform(rotationAngle: -0.02)
            }, completion: nil)
        }
    }
}
