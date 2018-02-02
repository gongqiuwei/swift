//
//  BaseViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  基本的访客视图界面

import UIKit

class BaseViewController: UITableViewController {
    
    /// 是否登录
//    var isLogin : Bool = false
    var isLogin : Bool = UserAccountTool.shareInstance.isLogin
    
    lazy var visitorView : VisitorView = VisitorView.visitorView()

    override func loadView() {
        
        /*
        // 判断用户是否登录
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        accountPath = accountPath + "/account.plist"
        
        if let account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount {
            // 有account对象
            if let expireDate = account.expire_date {
                // 有过期时间，判断是否过期
                let result = expireDate.compare(Date())
                // 降序，也就是expireDate大
                isLogin = (result == .orderedDescending)
            }
            
        }
         */
        
        // 判断要加载哪个View
        isLogin ? super.loadView() : setupVisitorView()
    }
}

//MARK:- UI界面
extension BaseViewController {
    fileprivate func setupVisitorView() {
        view = visitorView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClicked))
        
        visitorView.registBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClicked), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClicked), for: .touchUpInside)
    }
}

//MARK:- 事件处理
extension BaseViewController {
    
    @objc fileprivate func registerBtnClicked() {
        print("--registerBtnClicked--")
    }
    
    @objc fileprivate func loginBtnClicked() {
        let authorVc = OAuthorViewController()
        let authorNav = UINavigationController(rootViewController: authorVc)
        present(authorNav, animated: true, completion: nil)
    }
}
