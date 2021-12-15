//
//  UIButtonExtension.swift
//  chatApp
//
//  Created by Panchami Shenoy on 09/12/21.
//

import UIKit

extension UIButton {
    func pulsate(){
    let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.97
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 0.5
        
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.2
    flash.fromValue = 1
    flash.toValue = 0.1
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = 1
    layer.add(flash, forKey: nil)
    }
}
