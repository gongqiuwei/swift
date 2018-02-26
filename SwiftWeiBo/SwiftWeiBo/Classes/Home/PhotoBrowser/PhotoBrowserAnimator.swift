//
//  PhotoBrowserAnimator.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

// 面向协议开发，先根据协议确定需要的东西，然后让某个对象来提供
protocol PhotoBrowserAnimatorPresentDelegate: NSObjectProtocol {
    func startRectForPresent(indexPath: IndexPath) -> CGRect
    func endRectForPresent(indexPath: IndexPath) -> CGRect
    func imageViewForPresent(indexPath: IndexPath) -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    fileprivate var isPresent: Bool = false
    
    var indexPath: IndexPath?
    var presentDelegate: PhotoBrowserAnimatorPresentDelegate?
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
        
        guard let presentDelegate = presentDelegate, let indexPath = indexPath else {
            return
        }
        
        // 获取presentview
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // presentview添加到containerView中
        transitionContext.containerView.addSubview(presentView!)
        
        // 利用一个imageView来进行动画，动画完成后展示presentView
        let imageView = presentDelegate.imageViewForPresent(indexPath: indexPath)
        imageView.frame = presentDelegate.startRectForPresent(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        
        // 动画
        presentView?.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentDelegate.endRectForPresent(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            presentView?.alpha = 1.0
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
