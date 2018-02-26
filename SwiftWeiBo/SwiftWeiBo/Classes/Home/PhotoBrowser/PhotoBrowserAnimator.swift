//
//  PhotoBrowserAnimator.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject {
    fileprivate var isPresent: Bool = false
}


extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    // present动画控制
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    // dismiss动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
}


extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? animationForPresent(using: transitionContext) : animationForDismiss(using: transitionContext)
    }
    
    private func animationForPresent(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取presentview
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // presentview添加到containerView中
        transitionContext.containerView.addSubview(presentView!)
        
        // 动画
        presentView?.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentView?.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    private func animationForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取dismissView
        let dismissView = transitionContext.view(forKey: .from)
        
        // 动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView?.alpha = 0.0
        }) { (_) in
            // 移除dismissView
            dismissView?.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
    }
}
