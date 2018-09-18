//
//  TransitionButton.swift
//  TransitionButton
//
//  Created by Alaeddine M. on 11/1/15.
//  Copyright (c) 2015 Alaeddine M. All rights reserved.
//

import Foundation
import UIKit

/**
Stop animation style of the `TransitionButton`.
 
 - normal: just revert the button to the original state.
 - expand: expand the button and cover all the screen, useful to do transit animation.
 - shake: revert the button to original state and make a shaoe animation, useful to reflect that something went wrong
 */
public enum StopAnimationStyle {
    case normal
    case expand
    case shake
}




/// UIButton sublass for loading and transition animation. Useful for network based application or where you need to animate an action button while doing background tasks.
 
@IBDesignable open class TransitionButton : UIButton, UIViewControllerTransitioningDelegate, CAAnimationDelegate {
    
    /// the color of the spinner while animating the button
    @IBInspectable open var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }
    
    /// the background of the button in disabled state
    @IBInspectable open var disabledBackgroundColor: UIColor = UIColor.lightGray {
        didSet {
            self.setBackgroundImage(UIImage(color: disabledBackgroundColor), for: .disabled)
        }
    }
    
    /// the corner radius value to have a button with rounded corners.
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    private lazy var spiner: SpinerLayer = {
        let spiner = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(spiner)
        return spiner
    }()
    
    private var cachedTitle: String?
    private var cachedImage: UIImage?
    
    private let springGoEase:CAMediaTimingFunction  = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    private let shrinkCurve:CAMediaTimingFunction   = CAMediaTimingFunction(name: .linear)
    private let expandCurve:CAMediaTimingFunction   = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    private let shrinkDuration: CFTimeInterval      = 0.1

    public override init(frame: CGRect) {
        super.init(frame: frame)
         self.setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         self.setup()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
         self.setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.spiner.setToFrame(self.frame)
    }
    
    private func setup() {
        self.clipsToBounds  = true
        spiner.spinnerColor = spinnerColor
    }
    
    /**
     start animating the button, before starting a task, exemple: before a network call.
     */
    open func startAnimation() {
        self.isUserInteractionEnabled = false // Disable the user interaction during the animation
        self.cachedTitle            = title(for: .normal)  // cache title before animation of spiner
        self.cachedImage            = image(for: .normal)  // cache image before animation of spiner
        
        self.setTitle("",  for: .normal)                    // place an empty string as title to display a spiner
        self.setImage(nil, for: .normal)                    // remove the image, if any, before displaying the spinner
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2 // corner radius should be half the height to have a circle corners
        }, completion: { completed -> Void in
            self.shrink()   // reduce the width to be equal to the height in order to have a circle
            self.spiner.animation() // animate spinner
        })
    }
    
    /**
     stop animating the button.
     
     - Parameter animationStyle: the style of the stop animation.
     - Parameter revertAfterDelay: revert the button to the original state after a delay to give opportunity to custom transition.
     - Parameter completion: a callback closure to be called once the animation finished, it may be useful to transit to another view controller, example transit to the home screen from the login screen.
     
     */
    open func stopAnimation(animationStyle:StopAnimationStyle = .normal, revertAfterDelay delay: TimeInterval = 1.0, completion:(()->Void)? = nil) {

        let delayToRevert = max(delay, 0.2)

        switch animationStyle {
        case .normal:
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: completion)
            }
        case .shake:
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: nil)
                self.shakeAnimation(completion: completion)
            }
        case .expand:
            self.spiner.stopAnimation() // before animate the expand animation we need to hide the spiner first
            self.expand(completion: completion, revertDelay: delayToRevert) // scale the round button to fill the screen
        }
    }
    
    private func shakeAnimation(completion:(()->Void)?) {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        let point = self.layer.position
        keyFrame.values = [NSValue(cgPoint: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: point)]
        
        keyFrame.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        keyFrame.duration = 0.7
        self.layer.position = point

        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(keyFrame, forKey: keyFrame.keyPath)

        CATransaction.commit()
    }
    
    private func setOriginalState(completion:(()->Void)?) {
        self.animateToOriginalWidth(completion: completion)
        self.spiner.stopAnimation()
        self.setTitle(self.cachedTitle, for: .normal)
        self.setImage(self.cachedImage, for: .normal)
        self.isUserInteractionEnabled = true // enable again the user interaction
        self.layer.cornerRadius = self.cornerRadius
    }
 
    private func animateToOriginalWidth(completion:(()->Void)?) {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = (self.bounds.height)
        shrinkAnim.toValue = (self.bounds.width)
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)

        CATransaction.commit()
    }
    
    private func shrink() {
        let shrinkAnim                   = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue             = frame.width
        shrinkAnim.toValue               = frame.height
        shrinkAnim.duration              = shrinkDuration
        shrinkAnim.timingFunction        = shrinkCurve
        shrinkAnim.fillMode              = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    private func expand(completion:(()->Void)?, revertDelay: TimeInterval) {

        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        let expandScale = (UIScreen.main.bounds.size.height/self.frame.size.height)*2
        expandAnim.fromValue            = 1.0
        expandAnim.toValue              = max(expandScale,26.0)
        expandAnim.timingFunction       = expandCurve
        expandAnim.duration             = 0.4
        expandAnim.fillMode             = .forwards
        expandAnim.isRemovedOnCompletion  = false
        
        CATransaction.setCompletionBlock {
            completion?()
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + revertDelay) {
                self.setOriginalState(completion: nil)
                self.layer.removeAllAnimations() // make sure we remove all animation
            }
        }
        
        layer.add(expandAnim, forKey: expandAnim.keyPath)
        
        CATransaction.commit()
    }
    
}


public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image!.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}



