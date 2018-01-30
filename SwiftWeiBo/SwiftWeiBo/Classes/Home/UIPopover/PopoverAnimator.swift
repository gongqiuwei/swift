//
//  PopoverAnimator.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/30.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    /// 用来判断当前是present还是dismiss
    fileprivate lazy var isPresented : Bool = false
    fileprivate var presentedFrame : CGRect = CGRect.zero
    fileprivate var callBack : ((_ isPresented : Bool)->(Void))?
    
    /*swift语法点1
     简单的说 就是如果这个闭包是在这个函数结束前被调用，就是noescape。
     闭包在函数执行完成后才调用，调用的地方超过了函数的范围，就是逃逸闭包。
     网络请求后结束的回调就是逃逸的。因为发起请求后过一段时间闭包执行。
     在swift3.0中所有闭包都是默认非逃逸的，无需@noescape。如果是逃逸的就@escaping表示。
     延迟操作，网络加载等都需要@escaping。
     
     swift语法点2
     如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,
     那么自定义的构造函数会覆盖默认的init()构造函数，
     也就是说，在外面无法调用默认的init()构造函数来创建对象
     */
    init(presentedFrame : CGRect, callBack: @escaping (_ isPresented : Bool)->(Void) ){
        // 使用super提供的方法或者属性的时候，需要先调用super的init构造函数
//        super.init()
//        self.setValuesForKeys(["key":11])
        self.presentedFrame = presentedFrame;
        self.callBack = callBack
    }
}

//MARK:- 转场动画相关
extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    
    // UIPresentationController: present转场控制的类
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        //        print("presented--\(presented)")
        //        print("presenting--\(presenting)")
        //        print("source--\(source)")
        let pop = PopoverPresentationController(presentedViewController: presented, presenting: presenting)
        pop.presentedFrame = presentedFrame
        return pop
    }
    
    // present弹出时候的动画控制， 返回值是一个遵守UIViewControllerAnimatedTransitioning协议的NSObject对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    // 返回值的意思同上，这个是dismiss消失时候的动画控制
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        callBack!(isPresented)
        return self
    }
}

//MARK:- present&dismiss动画控制
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {

    // 动画时长，协议中必须实现方法
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // present&dismiss转场动画的代码，在这里写动画代码
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animateTransitionForPresent(using: transitionContext) : animateTransitionForDismiss(using: transitionContext)
    }
    
    // presented动画
    private func animateTransitionForPresent(using transitionContext: UIViewControllerContextTransitioning) {
        // 从transitionContext获取view
        /* OC
         UITransitionContextFromViewKey : 获取消失的View
         UITransitionContextToViewKey : 获取弹出的View
         
         swift3.0 (UITransitionContextViewKey是一个结构体)
         UITransitionContextViewKey.from:获取消失的View
         UITransitionContextViewKey.to : 获取弹出的View
         */
        // 0. 获取要弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // 1. 手动将view添加到contanerView中，自定义动画后，系统不会帮我们做
        transitionContext.containerView.addSubview(presentedView!)
        
        // 2. 利用transform做动画
        presentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
        // 设置view的锚点，transform动画是从锚点开始的，默认锚点在view中间
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        // 动画
        let time = transitionDuration(using: transitionContext)
        UIView .animate(withDuration: time, animations: { (_) in
            presentedView?.transform = CGAffineTransform.identity
        }, completion: { (_) in
            
            // 动画完成后必须调用这个方法，不然系统认为动画还在进行，不会结束
            transitionContext.completeTransition(true)
        })
    }
    
    // dismiss动画
    private func animateTransitionForDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1.获取消失的view
        let dismissView = transitionContext.view(forKey: .from)
        
        // 2.执行动画
        let time = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: time, animations: {
            // 注意，这里y不能为0，view会直接消息掉，系统原因
            dismissView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
        }) { (_) in
            // 告诉系统结束动画
            transitionContext.completeTransition(true)
            // 手动移除view
            dismissView?.removeFromSuperview()
        }
    }
}
