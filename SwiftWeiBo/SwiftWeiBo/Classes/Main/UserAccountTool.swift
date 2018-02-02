//
//  UserAccountTool.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//

import UIKit

/// 业务工具类
class UserAccountTool {
    
    // 类属性
    static let shareInstance : UserAccountTool = UserAccountTool()
    
    // 计算属性
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expire_date else{
            return false
        }
        
        // expiresDate比当前时间大，降序
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    /// swift中可以将get方法转换成计算属性
    // 只读计算属性
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print(accountPath)
        return accountPath + "/account.plist"
    }
    
    // 存储属性
    var account : UserAccount?
    
    init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
    /// 1. account存储路径的封装
    func getAccountPath() -> String {
        // 沙盒document目录下
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print(accountPath)
        return accountPath + "/account.plist"
    }
    
    func saveAccount(account : UserAccount) {
        self.account = account
        NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
    }
    
    /*
    func isLogin() -> Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expire_date else{
            return false
        }
        
        // expiresDate比当前时间大，降序
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
     */
}
