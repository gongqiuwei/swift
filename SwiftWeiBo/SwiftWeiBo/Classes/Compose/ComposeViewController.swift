//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    fileprivate lazy var titleView: ComposeTitleView = ComposeTitleView()
    @IBOutlet weak var textView: ComposeTextView!

    // tool底部的约束
    @IBOutlet weak var toolBarBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavItem()
        
        // scrollview的属性，当没有内容的时候也可以滑动
        textView.alwaysBounceVertical = true
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension ComposeViewController {
    fileprivate func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.titleView = titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    }
    
    @objc private func closeItemClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func sendItemClicked() {
        print("sendItemClicked")
    }
    
    /// 监听键盘frame改变的通知
    @objc fileprivate func keyboardWillChangeFrame(note: Notification) {
        // 获取键盘动画时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 键盘的结束位置, 是NSRect类型， 不能直接强制转换成 CGRect， 会失败
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let endY = endFrame.origin.y
        
        // 动画
        toolBarBottomConstraint.constant = UIScreen.main.bounds.height - endY
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
