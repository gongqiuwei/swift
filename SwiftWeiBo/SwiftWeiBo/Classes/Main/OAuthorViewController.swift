//
//  OAuthorViewController.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthorViewController: UIViewController {
    @IBOutlet fileprivate weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavgationBar()
        loadWebPage()
    }

    
}

//MARK:- UI界面
extension OAuthorViewController {
    /// 设置导航栏
    fileprivate func setupNavgationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthorViewController.closeClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "账号填充", style: .plain, target: self, action: #selector(OAuthorViewController.fillClicked))
        title = "登录页面"
    }
    
    /// 加载web授权页面
    fileprivate func loadWebPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}

//MARK:- 事件监听
extension OAuthorViewController {
    @objc fileprivate func closeClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillClicked() {
        guard !accountName.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "没有设置账号")
            return
        }
        guard !passwd.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "没有设置密码")
            return
        }
        
        let jsString = "document.getElementById('userId').value='\(accountName)';document.getElementById('passwd').value='\(passwd)';"
        webView.stringByEvaluatingJavaScript(from: jsString)
    }
}

//MARK:- UIWebViewDelegate
extension OAuthorViewController:UIWebViewDelegate{
    /// webView开始加载
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    /// webView结束加载
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /// webView加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 获取url
        guard let urlString = request.url?.absoluteString else {
            print("没有url")
            return true
        }
        
        // 判断是否有code
        guard urlString.contains("code=") else {
            // 不包含code=， 不做处理
            return true
        }
        
        // 包含code=, 截取code=后面的字符串
        guard let code = urlString.components(separatedBy: "code=").last else {
            // 截取不到字符串
            return true
        }
        
        // 利用code去获取access_token
        loadAccessToken(byCode: code)
        
        return false
    }
}

//MARK:- accesstoken
extension OAuthorViewController {
    fileprivate func loadAccessToken(byCode code: String) {
        // 请求网络
        NetworkTool.shareInstance.loadAccessToken(byCode: code) { (result:[String : Any]?, error:Error?) in
            
            // 可选绑定， 有值执行{}内语句
            if let error = error {
                print(error)
                return
            }
            
            // 判断result是否有值
            guard let resultDict = result  else {
                print("没有授权后的数据")
                return
            }
            
            // 有值的时候，取出里面的信息, 转化成UserAccount模型
            let account = UserAccount(dict: resultDict)
            
            // 调用acount对象的自定义log输出
            // print(String(reflecting: account))
            // print(account)
            
            // 根据access_token获取用户信息
            self.loadUserInfo(by: account)
        }
    }
    
    /// 加载用户信息
    fileprivate func loadUserInfo(by account : UserAccount) {
        guard let accessToken = account.access_token else {
            return
        }
        guard let uid = account.uid else {
            return
        }
        
        NetworkTool.shareInstance.loadUserInfo(byToken: accessToken, uid: uid) { (result:[String : Any]?, error:Error?) in
            
            if let error = error {
                print(error)
                return
            }
            
            // 判断result是否有值
            guard let resultDict = result else {
                print("没有授权后的数据")
                return
            }
            
            // 保存2个信息
            account.screen_name = resultDict["screen_name"] as? String
            account.avatar_large = resultDict["avatar_large"] as? String
            // print(String(reflecting: account))
            
            // 保存account到沙盒
            // 沙盒document目录下
//            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
//            
//            accountPath = accountPath + "/account.plist"
//            print(accountPath)
            
            // account对象归档存储
//            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountTool().accountPath)
            UserAccountTool.shareInstance.saveAccount(account: account)
        }
    }
}

