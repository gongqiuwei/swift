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
    var text : String?
    // 微博的ID
    var mid : Int = 0
    
    // 自定义构造函数
    init(with dict:[String:Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
