//
//  CustomTransitionViewController.swift
//  TransitionButton
//
//  Created by Alaeddine M. on 11/1/15.
//  Copyright (c) 2015 Alaeddine M. All rights reserved.
//

import UIKit

open class CustomTransitionViewController: UIViewController, UIViewControllerTransitioningDelegate {

    open override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .fullScreen
        }
        set {}
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeTransition(transitionDuration: 0.5, startingAlpha: 0.8)
    }
}
