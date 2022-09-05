//
//  DefaultSpinner.swift
//  TransitionButton
//
//  Created by Rahul Mayani on 11/09/20.
//  Copyright © 2020 ITechnoDev. All rights reserved.
//

import Foundation
import UIKit

class DefaultSpinner: TransitionButtonAnimationDelegate {
    
    /// setup spinner layer
       ///
       /// - Parameters:
       ///   - layer: layer Parent layer (Button layer)
       ///   - frame: frame of parant layer
       ///   - color: color of spinner
       ///   - spinnerSize: size of spinner layer
    func setupSpinnerAnimation(in layer: CAShapeLayer, frame: CGRect, color: UIColor, spinnerSize: UInt?) {
        
        self.setToFrame(frame, layer: layer)
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = Double.pi * 2
        rotate.duration = 0.4
        rotate.timingFunction = CAMediaTimingFunction(name: .linear)
        
        rotate.repeatCount = HUGE
        rotate.fillMode = .forwards
        rotate.isRemovedOnCompletion = false
        layer.add(rotate, forKey: rotate.keyPath)
    }
    
    func setToFrame(_ frame: CGRect, layer: CAShapeLayer) {
        let radius:CGFloat = (frame.height / 2) * 0.5
        layer.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        let center = CGPoint(x: frame.height / 2, y: layer.bounds.center.y)
        let startAngle = 0 - Double.pi/2
        let endAngle = Double.pi * 2 - Double.pi/2
        let clockwise: Bool = true
        layer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).cgPath
    }
}
