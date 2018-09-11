//
//  OrgTransition.swift
//  CareButtons
//
//  Created by Hiroka Yago on 2018/01/02.
//  Copyright © 2018 Hiroka Yago. All rights reserved.
//

import Foundation
import UIKit

class OrgTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    private var isPresent = false

    //transitioning
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }

    //animate
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }

    // 遷移時のTrastion処理
    private func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!

        toViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 5)

        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)

        //        let visualEffectView = UIVisualEffectView(frame: toViewController.view.frame)
        //        visualEffectView.effect = UIBlurEffect(style: .light)
        //        toViewController.view.insertSubview(visualEffectView, at: 0)
        //
        //        visualEffectView.alpha = 0.0

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            // 遷移のアニメーションなど
            //            visualEffectView.alpha = 1.0

            toViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 1)

        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

    // 復帰時のTrastion処理
    private func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            // 遷移のアニメーションなど
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
