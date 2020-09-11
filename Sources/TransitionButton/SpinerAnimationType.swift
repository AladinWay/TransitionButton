//
//  SpinerAnimationType.swift
//  TransitionButton
//
//  Created by Rahul Mayani on 11/09/20.
//  Copyright © 2020 ITechnoDev. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable:next class_delegate_protocol
protocol TransitionButtonAnimationDelegate {
    
    func setupSpinnerAnimation(in layer: CAShapeLayer, frame: CGRect, color: UIColor, spinnerSize: UInt?)
}

/**
Enum of animation types used for spiner animation.

- DefaultSpinner:          LineSpinFadeLoader animation.
- BallRotate:              BallRotate animation.
- BallPulse:               BallPulse animation.
- AudioEqualizer:          AudioEqualizer animation.
- BallClipRotate:          BallClipRotate animation.
- BallScale:               BallScale animation.
*/
public enum SpinerAnimationType: Int, CaseIterable {

    /**
    DefaultSpinner.

    - returns: Instance of DefaultSpinner.
    */
    case defaultSpinner = 0
    /**
    BallRotate.

    - returns: Instance of SpinerBallRotate.
    */
    case ballRotate = 1
    /**
    BallPulse.

    - returns: Instance of SpinerBallPulse.
    */
    case ballPulse = 2
    /**
    AudioEqualizer.

    - returns: Instance of SpinerAudioEqualizer.
    */
    case audioEqualizer = 3
    /**
    BallClipRotate.

    - returns: Instance of SpinerBallClipRotate.
    */
    case ballClipRotate = 4
    /**
    BallScale.

    - returns: Instance of SpinerBallScale.
    */
    case ballScale = 5
    
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func animation() -> TransitionButtonAnimationDelegate {
        switch self {
        case .defaultSpinner:
            return DefaultSpinner()
        case .ballRotate:
            return SpinerBallRotate()
        case .ballPulse:
            return SpinerBallPulse()
        case .audioEqualizer:
            return SpinerAudioEqualizer()
        case .ballClipRotate:
            return SpinerBallClipRotate()
        case .ballScale:
            return SpinerBallScale()
        }
    }
}

enum TransitionButtonAnimationShape {
    case circle
    case ringTwoHalfVertical
    case ringTwoHalfHorizontal
    case line

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2

        switch self {
        case .circle:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: 0,
                        endAngle: CGFloat(2 * Double.pi),
                        clockwise: false)
            layer.fillColor = color.cgColor
        case .ringTwoHalfVertical:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-3 * Double.pi / 4),
                        endAngle: CGFloat(-Double.pi / 4),
                        clockwise: true)
            path.move(
                to: CGPoint(x: size.width / 2 - size.width / 2 * cos(CGFloat(Double.pi / 4)),
                            y: size.height / 2 + size.height / 2 * sin(CGFloat(Double.pi / 4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-5 * Double.pi / 4),
                        endAngle: CGFloat(-7 * Double.pi / 4),
                        clockwise: false)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .ringTwoHalfHorizontal:
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(3 * Double.pi / 4),
                        endAngle: CGFloat(5 * Double.pi / 4),
                        clockwise: true)
            path.move(
                to: CGPoint(x: size.width / 2 + size.width / 2 * cos(CGFloat(Double.pi / 4)),
                            y: size.height / 2 - size.height / 2 * sin(CGFloat(Double.pi / 4)))
            )
            path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                        radius: size.width / 2,
                        startAngle: CGFloat(-Double.pi / 4),
                        endAngle: CGFloat(Double.pi / 4),
                        clockwise: true)
            layer.fillColor = nil
            layer.strokeColor = color.cgColor
            layer.lineWidth = lineWidth
        case .line:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                cornerRadius: size.width / 2)
            layer.fillColor = color.cgColor
        }

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
}
