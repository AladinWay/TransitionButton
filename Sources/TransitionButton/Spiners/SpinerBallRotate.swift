//
//  SpinerBallRotate.swift
//  TransitionButton
//
//  Created by Rahul Mayani on 11/09/20.
//  Copyright © 2020 ITechnoDev. All rights reserved.
//

import Foundation
import UIKit

class SpinerBallRotate: TransitionButtonAnimationDelegate {
   
    func setupSpinnerAnimation(in layer: CAShapeLayer, frame: CGRect, color: UIColor, spinnerSize: UInt?) {
    
        var defaultPadding: CGFloat = 10.0
        var sizeofSpinner: CGFloat?
        if spinnerSize != nil {
            defaultPadding = 0.0
            sizeofSpinner =  max(CGFloat(spinnerSize!) - defaultPadding, 1.0)
        }
        var size =  max(min(frame.width, frame.height) - defaultPadding, 1.0)
        if sizeofSpinner != nil && sizeofSpinner! > (size - defaultPadding) {
            defaultPadding = 10.0
            size =  max(min(frame.width, frame.height) - defaultPadding, 1.0)
            sizeofSpinner = size
        }
        
        let center = CGPoint(x: (size/2) + (defaultPadding / 2), y: (size / 2) + (defaultPadding / 2))
        let circleSize = sizeofSpinner != nil ? max(min(sizeofSpinner! / 6, size / 6), 1.0) : size / 6
      
        for i in 0 ..< 5 {
            let factor = Float(i) * 1 / 5
            let circle = TransitionButtonAnimationShape.circle.layerWith(size: CGSize(width: circleSize, height: circleSize), color: color)
            let animation = rotateAnimation(factor, x: center.x, y: center.y, size: CGSize(width: (sizeofSpinner != nil ? sizeofSpinner! : size) - circleSize, height: (sizeofSpinner != nil ? sizeofSpinner! : size) - circleSize))
            
            circle.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
        
    }
        
    
    /// Rotate animation
    ///
    /// - Parameters:
    ///   - rate: rate of rotation
    ///   - x: X value of center
    ///   - y: Y value of center
    ///   - size: size of spinner
    /// - Returns: Rotate Animation group
    func rotateAnimation(_ rate: Float, x: CGFloat, y: CGFloat, size: CGSize) -> CAAnimationGroup {
        let duration: CFTimeInterval = 1.5
        let fromScale = 1 - rate
        let toScale = 0.2 + rate
        let timeFunc = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + rate, 0.25, 1)
        
        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = duration
        scaleAnimation.repeatCount = HUGE
        scaleAnimation.fromValue = fromScale
        scaleAnimation.toValue = toScale
        
        // Position animation
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        positionAnimation.repeatCount = HUGE
        positionAnimation.path = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: size.width / 2, startAngle: CGFloat(3 * Double.pi * 0.5), endAngle: CGFloat(3 * Double.pi * 0.5 + 2 * Double.pi), clockwise: true).cgPath
        
        // Aniamtion
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, positionAnimation]
        animation.timingFunction = timeFunc
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
}
