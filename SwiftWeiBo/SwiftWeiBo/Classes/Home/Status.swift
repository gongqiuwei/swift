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
//    var created_at : String? {
//        didSet{
//            guard let created_at = created_at else {
//                return
//            }
//            
//            createAtText = Date.createAtText(from: created_at)
//        }
//    }
    // 微博来源
    // 示例："<a href=\"http://app.weibo.com/t/feed/2J8wRB\" rel=\"nofollow\">iPhone 7</a>"
    var source : String?
//    var source : String? {
//        // 处理微博来源文字
//        didSet{
//            // 判断输入的数据
//            // 多重guard判断，swift3.0之前用where， swift3.0用 ， 隔开
//            // 相当于先guard let source = source else{}, 
//            // 然后guard source != "" else{}
//            guard let source = source, source != "" else {
//                return
//            }
//            
//            // 1.查找 "> 的位置
//            // 2.查找 </ 的位置
//            let beginIndex = (source as NSString).range(of: "\">").location + 2
//            let length = (source as NSString).range(of: "</").location - beginIndex
//            sourceText = (source as NSString).substring(with: NSRange(location: beginIndex, length: length))
//        }
//    }
    // 微博的正文
    var text: String?
    // 微博的ID
    var mid: Int = 0
    // 微博配图
    var pic_urls: [[String: String]]?
    
    var user : User?
    
    // 自定义构造函数
    init(with dict:[String:Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
        if let userDict = dict["user"] as? [String:Any] {
            user = User(dict: userDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    // MARK:- 自己附加处理属性
//    var sourceText:String?
//    var createAtText:String?
}
