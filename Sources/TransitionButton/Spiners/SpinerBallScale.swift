//
//  SpinerBallScale.swift
//  TransitionButton
//
//  Created by Rahul Mayani on 11/09/20.
//  Copyright © 2020 ITechnoDev. All rights reserved.
//

import Foundation
import UIKit

class SpinerBallScale: TransitionButtonAnimationDelegate {

    func setupSpinnerAnimation(in layer: CAShapeLayer, frame: CGRect, color: UIColor, spinnerSize: UInt?) {
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0, 0.2, 0.4]

        // Scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")

        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 0.8

        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")

        opacityAnimation.duration = duration
        opacityAnimation.keyTimes = [0, 0.05, 1]
        opacityAnimation.values = [0, 1, 0]

        // Animation
        let animation = CAAnimationGroup()

        animation.animations = [scaleAnimation, opacityAnimation]
        #if swift(>=4.2)
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        #else
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        #endif
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw balls
        for i in 0 ..< 3 {
            
            let circle = TransitionButtonAnimationShape.circle.layerWith(size: CGSize(width: frame.width, height: frame.height), color: color)
            let frame = CGRect(x: (layer.bounds.width - frame.width) / 2,
                               y: (layer.bounds.height - frame.height) / 2,
                               width: frame.width,
                               height: frame.height)

            animation.beginTime = beginTime + beginTimes[i]
            circle.frame = frame
            circle.opacity = 0
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
}
