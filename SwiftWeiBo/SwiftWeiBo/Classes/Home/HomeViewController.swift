//
//  HomeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit


class HomeViewController: BaseViewController {

    //MARK: - 懒加载属性
    fileprivate lazy var titleButton : TitleButton = TitleButton()
    fileprivate lazy var isPresented : Bool = false
    
    //MARK: - 系统周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 没有登录状态下
        guard isLogin else {
            // 添加旋转动画
            visitorView.addRotation()
            return;
        }
        
        // 登录状态下
        setupNavgationBar()
    }

}

//MARK:- UI设定
extension HomeViewController {
    /// 设置导航栏
    fileprivate func setupNavgationBar() {
        /*
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named:"navigationbar_friendattention"), for: .normal)
        leftBtn.setImage(UIImage(named:"navigationbar_friendattention_highlighted"), for: .highlighted)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
         */
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleButton.setTitle("iOSCoder", for: .normal)
        titleButton.addTarget(self, action: #selector(HomeViewController.titleBtnClicked(sender:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}


//MARK:- 事件处理
extension HomeViewController {
    @objc fileprivate func titleBtnClicked(sender: TitleButton) {
        sender.isSelected = !sender.isSelected
        
        let popover = PopoverViewController()
        // 设置custom的目的是使后面的tabbarcontroller不会消失， 默认会移除
        popover.modalPresentationStyle = .custom
        popover.transitioningDelegate = self
        
        present(popover, animated: true, completion: nil)
    }
}

//MARK:- 转场动画相关
extension HomeViewController : UIViewControllerTransitioningDelegate{
    
    // UIPresentationController: present转场控制的类
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        print("presented--\(presented)")
//        print("presenting--\(presenting)")
//        print("source--\(source)")
        
        return PopoverPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // present弹出时候的动画控制， 返回值是一个遵守UIViewControllerAnimatedTransitioning协议的NSObject对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    // 返回值的意思同上，这个是dismiss消失时候的动画控制
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
}

//MARK:- present&dismiss动画控制
extension HomeViewController : UIViewControllerAnimatedTransitioning {
    
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
