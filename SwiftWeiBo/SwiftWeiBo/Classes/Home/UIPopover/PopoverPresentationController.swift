//
//  PopoverPresentationController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {

    var presentedFrame : CGRect = CGRect.zero
    private lazy var coverView : UIView = UIView()
    
    /*
     present时的view层次结构：
        trasitionView(即为containerView) -> presentedController.view(要present出来的控制器的view) -> subViews in view(控制器内部的子控件)
     */
    /// containerView开始布局
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 设置present出来的view的尺寸
        presentedView?.frame = presentedFrame;
        presentedView?.backgroundColor = UIColor.clear
        
        // 加一层蒙版
        setupCoverView()
    }
    
    /// 设置蒙版
    private func setupCoverView() {
        containerView?.insertSubview(coverView, at: 0)
        
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        // ?? 空合运算符 表示的意思：a != nil ? a! : b
        coverView.frame = (containerView?.bounds) ?? CGRect.zero
        
        // 添加手势事件
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PopoverPresentationController.coverViewClicked))
        coverView.addGestureRecognizer(tapGes)
    }
    
    /// 点击事件监听
    @objc private func coverViewClicked() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

