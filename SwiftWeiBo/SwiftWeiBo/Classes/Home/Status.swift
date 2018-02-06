//
//  Status.swift
//  SwiftWeiBo
//
//  Created by apple on 2018/2/4.
//  Copyright © 2018年 gongqiuwei. All rights reserved.
//  微博模型

import UIKit

class Status: NSObject {
    
    // MARK:- 属性
    // 微博创建时间
    var created_at : String?

    // 微博来源
    // 示例："<a href=\"http://app.weibo.com/t/feed/2J8wRB\" rel=\"nofollow\">iPhone 7</a>"
    var source : String?
    // 微博的正文
    var text: String?
    // 微博的ID
    var mid: Int = 0
    // 微博配图
    var pic_urls: [[String: String]]?
    
    var user : User?
    var retweeted_status: Status?
    
    // 自定义构造函数
    init(with dict:[String:Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
        // 处理用户数据
        if let userDict = dict["user"] as? [String:Any] {
            user = User(dict: userDict)
        }
        
        // 处理转发数据
        if let retweetedDict = dict["retweeted_status"] as? [String: Any] {
            retweeted_status = Status(with: retweetedDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    // MARK:- 自己附加处理属性
//    var sourceText:String?
//    var createAtText:String?
}
