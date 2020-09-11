//
//  SpinerAudioEqualizer.swift
//  TransitionButton
//
//  Created by Rahul Mayani on 11/09/20.
//  Copyright © 2020 ITechnoDev. All rights reserved.
//

import Foundation
import UIKit

class SpinerAudioEqualizer: TransitionButtonAnimationDelegate {

    func setupSpinnerAnimation(in layer: CAShapeLayer, frame: CGRect, color: UIColor, spinnerSize: UInt?) {
        let lineSize = frame.width / 12
        let x = (layer.bounds.width - lineSize * 7) / 2
        let y = (layer.bounds.height - frame.height) / 2
        let duration: [CFTimeInterval] = [4.3, 2.5, 1.7, 3.1]
        let values = [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.9, 0.4, 0.15, 0.18, 0.75, 0.01]

        // Draw lines
        for i in 0 ..< 4 {
            let animation = CAKeyframeAnimation()

            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []

            for j in 0 ..< values.count {
                let heightFactor = values[j]
                let height = frame.height * CGFloat(heightFactor)
                let point = CGPoint(x: 0, y: frame.height - height)
                let path = UIBezierPath(rect: CGRect(origin: point, size: CGSize(width: lineSize, height: height - 20)))

                animation.values?.append(path.cgPath)
            }
            animation.duration = duration[i]
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false

            let line = TransitionButtonAnimationShape.line.layerWith(size: CGSize(width: lineSize, height: frame.height), color: color)
            let frame = CGRect(x: x + lineSize * 2 * CGFloat(i),
                               y: y,
                               width: lineSize,
                               height: frame.height)

            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}
